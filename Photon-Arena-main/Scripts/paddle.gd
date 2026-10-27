extends CharacterBody2D

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
	if (Input.is_action_pressed("Up_" + str(PaddleID))):
		global_position.y -= speed
	
	if (Input.is_action_pressed("Down_" + str(PaddleID))):
		global_position.y += speed
	
		
	global_position.y = clamp(global_position.y, 80, get_viewport_rect().size.y -80)

func reset():
	global_position.y = get_viewport_rect().size.y / 2
