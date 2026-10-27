extends Node

@onready var mm_bkgnd: AudioStreamPlayer = $mm_bkgnd

func fade_out(duration := 1.0):
	var tween = get_tree().create_tween()
	tween.tween_property(mm_bkgnd, "volume_db", -80, duration)
