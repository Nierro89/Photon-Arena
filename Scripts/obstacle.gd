extends StaticBody2D

@export var rotation_speed : float = 1.0  # Radians per second

func _process(delta: float) -> void:
	rotation += rotation_speed * delta
