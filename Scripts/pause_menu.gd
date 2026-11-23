extends CanvasLayer


@onready var hover: AudioStreamPlayer = $hover


func open() -> void:
	visible = true
	get_tree().paused = true


func close() -> void:
	visible = false
	get_tree().paused = false


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_resume_button_pressed() -> void:
	close()


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel"):
		return
	else:
		toggle()


func toggle() -> void:
	if get_tree().paused:
		close()
	else:
		open()


func _on_quit_button_mouse_entered() -> void:
	hover.play()


func _on_menu_button_mouse_entered() -> void:
	hover.play()


func _on_restart_button_mouse_entered() -> void:
	hover.play()


func _on_resume_button_mouse_entered() -> void:
	hover.play()
