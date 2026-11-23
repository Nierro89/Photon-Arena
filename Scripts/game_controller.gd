extends Node2D

# Variables
var countdownAnim : AnimationPlayer
var Ball: PackedScene = load("res://Scenes/ball.tscn")
signal resetPaddle

@onready var music_bg: AudioStreamPlayer = $music_bg
@export var obstacle_scene: Array[PackedScene] #obstacles 
@onready var pause_menu: CanvasLayer = $PauseMenu

const VIEWPORT_WIDTH = 1152
const VIEWPORT_HEIGHT = 648
const EDGE_MARGIN = 120
const MAX_OBSTACLES := 12 
const MIN_OBSTACLES := 0
const MIN_SPACING := 120.0

func _ready():
	startGame()
	music_bg.play()
	

func startGame():
	countdownAnim = get_tree().get_first_node_in_group("countdown_animation")
	var paddles = get_tree().get_nodes_in_group("paddle")
	
	for paddle in paddles:
		connect("resetPaddle", paddle.reset)
	
	Global.P1_Score = 0
	Global.P2_Score = 0
	Global.cpu_level = 1 
	Global.new_high_score = false
	resetPaddle.emit()
	
	startNextRound()

func startNextRound():
	var match_over: bool = false
	if Global.game_mode == Global.GameMode.SINGLE_PLAYER:
		match_over = Global.P2_Score == 10
	else:
		match_over = Global.P1_Score == 10 or Global.P2_Score == 10
	
	if match_over:
		call_deferred("endGame")
		return

	spawn_obstacles()
	
	countdownAnim.play("countdown")
	await countdownAnim.animation_finished
	spawnBall()

func endGame():
	get_tree().change_scene_to_file("res://Scenes/end screen.tscn")

func spawnBall():
	var direction := Vector2.from_angle(randf() * TAU)
	var newBall = Ball.instantiate()
	newBall.global_position = get_viewport().get_visible_rect().size / 2
	
	add_child(newBall)
	newBall.launch(direction)

func spawn_obstacles() -> void:
	for old in get_tree().get_nodes_in_group("obstacles"):
		old.queue_free()
	var round_number: int = Global.P1_Score + Global.P2_Score + 1
	var count: int = clampi(MIN_OBSTACLES + round_number / 3, MIN_OBSTACLES, MAX_OBSTACLES)
	var placed: Array[Vector2] = []
	for i in count:
		var scene: PackedScene = obstacle_scene.pick_random()
		var instance := scene.instantiate()
		instance.position = _find_open_position(i % 2 == 0, placed)
		placed.append(instance.position)
		instance.add_to_group("obstacles")
		add_child(instance)

func _find_open_position(left_side: bool, placed: Array[Vector2]) -> Vector2:
	for attmept in 25:
		var pos:= get_random_spawn_position(left_side)
		var clear := true
		for other in placed:
			if pos.distance_to(other) < MIN_SPACING:
				clear = false
				break
		if clear:
			return pos
	return get_random_spawn_position(left_side)

func get_random_spawn_position(left_side: bool) -> Vector2:
	var half_width = VIEWPORT_WIDTH / 2.0
	var min_x: float
	var max_x: float

	if left_side:
		min_x = EDGE_MARGIN
		max_x = half_width - EDGE_MARGIN
	else:
		min_x = half_width + EDGE_MARGIN
		max_x = VIEWPORT_WIDTH - EDGE_MARGIN
	
	var x = randf_range(min_x, max_x)
	var y = randf_range(EDGE_MARGIN, VIEWPORT_HEIGHT - EDGE_MARGIN)
	return Vector2(x, y)

