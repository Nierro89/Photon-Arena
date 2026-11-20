extends AnimatableBody2D

@export var travel: float = 70.0
@export var half_period: float = 1.1

func _ready() -> void:
	sync_to_physics = true
	var tween := create_tween().set_loops()
	tween.tween_property(self, "position:y", position.y + travel, half_period) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", position.y - travel, half_period) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
