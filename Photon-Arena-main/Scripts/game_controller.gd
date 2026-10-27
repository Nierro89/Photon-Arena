extends Node2D

# Variables
var countdownAnim : AnimationPlayer
var Ball: PackedScene = load("res://Scenes/ball.tscn")
signal resetPaddle

@onready var music_bg: AudioStreamPlayer = $music_bg
@export var obstacle_scene: PackedScene #obstacle scene loadpoint.
@export var spawn_count: int = 6 # Number of instances to create

const VIEWPORT_WIDTH = 1152
const VIEWPORT_HEIGHT = 648
const EDGE_MARGIN = 100

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
	resetPaddle.emit()
	
	startNextRound()

func startNextRound():
	if (Global.P1_Score == 10 or Global.P2_Score == 10):
		call_deferred("endGame")
		return

	# Remove existing rotators before spawning new ones
	for rotator in get_tree().get_nodes_in_group("rotators"):
		rotator.queue_free()

	spawn_rotators()
	
	countdownAnim.play("countdown")
	await countdownAnim.animation_finished
	spawnBall()

func endGame():
	get_tree().change_scene_to_file("res://Scenes/end screen.tscn")

func spawnBall():
	var direction = Vector2.from_angle(randf_range(0, 359))
	var newBall = Ball.instantiate()
	newBall.global_position = get_viewport().get_visible_rect().size / 2

	newBall.launch(direction)
	get_tree().root.get_child(1).add_child(newBall)

func spawn_rotators() -> void:
	var half_count = spawn_count / 2.0
	var left_count = int(ceil(half_count))
	var right_count = spawn_count - left_count

	# Left side spawns
	for i in range(left_count):
		var rotator_instance = obstacle_scene.instantiate()
		rotator_instance.position = get_random_spawn_position(true)
		rotator_instance.add_to_group("rotators")
		add_child(rotator_instance)

	# Right side spawns
	for i in range(right_count):
		var rotator_instance = obstacle_scene.instantiate()
		rotator_instance.position = get_random_spawn_position(false)
		rotator_instance.add_to_group("rotators")
		add_child(rotator_instance)

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
