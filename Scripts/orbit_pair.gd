extends Node2D

@export var orbtit_speed: float = 1.6

func _process(delta): rotation += orbtit_speed * delta
