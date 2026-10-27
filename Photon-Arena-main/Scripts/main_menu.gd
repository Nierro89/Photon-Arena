extends MarginContainer

@onready var hover : AudioStreamPlayer = $hover

func _ready():
	if not AudioManager.mm_bkgnd.playing:
		AudioManager.mm_bkgnd.play()


func _on_play_pressed():
	start_game(Global.GameMode.TWO_PLAYER)


func _on_one_player_pressed():
	start_game(Global.GameMode.SINGLE_PLAYER)


func start_game(mode: Global.GameMode):
	AudioManager.fade_out(2.0)
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Scene/main.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_play_mouse_entered():
	hover.play()


func _on_one_player_mouse_entered():
	hover.play()


func _on_quit_mouse_entered() -> void:
	hover.play()


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_settings_mouse_entered() -> void:
	hover.play()
