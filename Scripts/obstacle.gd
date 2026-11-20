extends AnimatableBody2D

@export var rotation_speed: float = 1.0

func _physics_process(delta: float) -> void:
	rotation += rotation_speed * delta

func surface_velocity_at(contact: Vector2) -> Vector2:
	var radius := contact - global_position
	return Vector2(-radius.y, radius.x) * rotation_speed
