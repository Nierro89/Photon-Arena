extends Button

#Called when the button is loaded into the scene
func _ready():
	pressed.connect(quit)

#Called when the button is pressed
func quit():
	get_tree().quit()
