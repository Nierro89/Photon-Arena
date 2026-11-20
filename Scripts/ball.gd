extends CharacterBody2D

@export var speed_increase_fraction: float = 0.005
@onready var sfx_bounce: AudioStreamPlayer = $sfx_bounce
var speed: float = 600.0
const MIN_HORIZONTAL_FRACTION := 0.35
const MIN_VERTICAL_FRACTION := 0.35

func launch(direction:Vector2):
	velocity = direction * speed
	_enforce_minimum_horizontal()
	_enforce_minimum_vertical()
	
func _enforce_minimum_vertical() -> void:
	var current_speed := velocity.length()
	var min_y := current_speed * MIN_VERTICAL_FRACTION
	if abs(velocity.y) >= min_y:
		return
	var y_sign := 1.0 if randf() < 0.5 else -1.0
	var x_sign := signf(velocity.x)
	if x_sign == 0.0:
		x_sign = 1.0
	velocity.y - y_sign * min_y
	velocity.x = x_sign * sqrt(current_speed * current_speed - velocity.y * velocity.y)

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

func _process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if not collision:
		return

	velocity = velocity.bounce(collision.get_normal())
	var collider = collision.get_collider()
	if collider != null and collider.has_method("surface_velocity_at"):
		velocity += collider.surface_velocity_at(collision.get_position())

	velocity = velocity.normalized() * speed
	_enforce_minimum_horizontal()
	
	speed += 600.0 * speed_increase_fraction
	sfx_bounce.play()
