extends CharacterBody2D

@export var speed_increase_multiplier: float = 0.20
@onready var sfx_bounce: AudioStreamPlayer = $sfx_bounce
var speed: float = 600.0

func launch(direction:Vector2):
	velocity = direction * speed
	
func _process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		speed *= speed_increase_multiplier
		sfx_bounce.play()

