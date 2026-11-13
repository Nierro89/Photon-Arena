extends Node

@onready var mm_bkgnd: AudioStreamPlayer = $mm_bkgnd

func fade_out(duration := 1.0):
	var tween = get_tree().create_tween()
	tween.tween_property(mm_bkgnd, "volume_db", -80, duration)

func transition_to_arena() -> void:
	fade_out(2.0)
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
