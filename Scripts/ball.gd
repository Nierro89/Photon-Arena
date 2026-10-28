extends CharacterBody2D

@export var speed_increase_fraction: float = 0.20
@onready var sfx_bounce: AudioStreamPlayer = $sfx_bounce
var speed: float = 600.0
const MIN_HORIZONTAL_FRACTION := 0.35

func _enforce_minimum_horizontal():
	var current_speed := velocity.length()
	var min_x := current_speed * MIN_HORIZONTAL_FRACTION
	if abs(velocity.x) >= min_x:
		return

	var x_sign := signf(velocity.x)
	if x_sign == 0.0:
		x_sign = 1.0 if randf() < 0.5 else -1.0
	
	var y_sign := signf(velocity.y)
	if y_sign == 0.0:
		y_sign = 1.0
	
		var new_x := x_sign * min_x
		var new_y := y_sign * sqrt(current_speed * current_speed - new_x * new_x)
		velocity = Vector2(new_x, new_y)

func launch(direction:Vector2):
	velocity = direction * speed
	
func _process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		_enforce_minimum_horizontal()
		speed += 600.0 * speed_increase_fraction
		sfx_bounce.play()

