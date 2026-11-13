extends MarginContainer

@onready var hover : AudioStreamPlayer = $hover

func _ready() -> void:
	if not AudioManager.mm_bkgnd.playing:
		AudioManager.mm_bkgnd.play()

func _on_hard_pressed() -> void:
	_difficulty_selected("hard")

func _on_normal_pressed() -> void:
	_difficulty_selected("normal")

func _on_easy_pressed() -> void:
	_difficulty_selected("easy")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _difficulty_selected(difficulty: String) -> void:
	Global.cpu_difficulty = difficulty
	AudioManager.transition_to_arena()

func _on_back_mouse_entered() -> void:
	hover.play()


func _on_hard_mouse_entered() -> void:
	hover.play()


func _on_normal_mouse_entered() -> void:
	hover.play()

func _on_easy_mouse_entered() -> void:
	hover.play()
