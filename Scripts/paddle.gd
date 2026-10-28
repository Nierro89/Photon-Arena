extends CharacterBody2D
@export var reaction_time: float = 0.3
@export var aim_error: float = 60.0
@export var cpu_max_speed: float = 400.0

var target_y: float = 0.0
var decision_timer: float = 0.0
#variables
@export var PaddleID: int = 1
var speed = 8
@onready var PaddleSprite: Sprite2D = $Sprite2D

# When the paddle is loaded into the game, on the main Scene starting, this code will run.
func _ready():
	if PaddleID == 1:
		PaddleSprite.texture = load("res://Sprites/paddle_2.png")
	elif PaddleID == 2:
		PaddleSprite.texture = load("res://Sprites/paddle_1.png")
	else:
		printerr("The PaddleID has not been asigned to 1 or 2.")

#The process function runs every frame the game calls.
func _process(_delta):
	if PaddleID == 2 and Global.game_mode == Global.GameMode.SINGLE_PLAYER:
		cpu_process(_delta)
		return
	if (Input.is_action_pressed("Up_" + str(PaddleID))):
		global_position.y -= speed
	
	if (Input.is_action_pressed("Down_" + str(PaddleID))):
		global_position.y += speed
	
		
	global_position.y = clamp(global_position.y, 80, get_viewport_rect().size.y -80)

func reset():
	global_position.y = get_viewport_rect().size.y / 2

func cpu_process(delta: float):
	var ball = get_tree().get_first_node_in_group("ball")
	decision_timer -= delta

	if ball == null:
		target_y = get_viewport_rect().size.y / 2.0
	elif decision_timer <= 0.0:
		decision_timer = reaction_time
		if ball.velocity.x > 0:
			target_y = predict_intercept_y(ball) + randf_range(-aim_error, aim_error)
		else:
			target_y = get_viewport_rect().size.y / 2.0

	var diff = target_y - global_position.y
	global_position.y += clamp(diff, -cpu_max_speed * delta, cpu_max_speed * delta)
	global_position.y = clamp(global_position.y, 80, get_viewport_rect().size.y -80)

func predict_intercept_y(ball: CharacterBody2D):
	var pos = ball.global_position
	var vel = ball.velocity
	var top := 0.0
	var bottom := get_viewport_rect().size.y
	var time_step := 0.02
	var steps := 0

	while pos.x < global_position.x and steps < 5000:
		steps += 1
		pos += vel * time_step

		if pos.y < top:
			pos.y = top
			vel.y = abs(vel.y)
		elif pos.y > bottom:
			pos.y = bottom
			vel.y = -abs(vel.y)

	return pos.y
