extends Button
 
#Called when the button is loaded into the scene
func _ready():
	pressed.connect(playAgain)

#Called when the button is pressed.
func playAgain():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
