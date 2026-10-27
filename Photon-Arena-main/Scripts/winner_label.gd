extends Label


@onready var gamov_sfx: AudioStreamPlayer = $gamov_sfx
@onready var hover: AudioStreamPlayer = $button

func _ready():
	if(Global.P1_Score > Global.P2_Score):
		text = "red wins!"
		gamov_sfx.play()
	else:
		text = "blue wins!"
		gamov_sfx.play()


func _on_play_again_mouse_entered():
	hover.play()


func _on_quit_mouse_entered():
	hover.play()
