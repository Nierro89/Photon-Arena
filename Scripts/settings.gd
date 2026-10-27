extends CanvasLayer

@onready var hover : AudioStreamPlayer = $hover

func _on_audio_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/audio.tscn")


func _on_audio_button_mouse_entered() -> void:
	hover.play()

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_return_button_mouse_entered() -> void:
	hover.play()
