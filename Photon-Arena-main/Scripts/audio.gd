extends TextureRect

@onready var master_slide: Slider = $master_slide
@onready var music_slide: Slider = $music_slide
@onready var sfx_slide: Slider = $sfx_slide
@onready var mute_box: CheckBox = $mute_box
@onready var reset: Button = $reset
@onready var hover : AudioStreamPlayer = $hover

var master_index: int
var music_index: int
var sfx_index: int


func _ready() -> void:
	master_index = AudioServer.get_bus_index("Master")
	music_index = AudioServer.get_bus_index("music")
	sfx_index = AudioServer.get_bus_index("sfx")
	master_slide.value_changed.connect(_on_master_slide_value_changed)
	mute_box.pressed.connect(_on_mute_box_pressed)
	reset.pressed.connect(_on_reset_pressed)
	master_slide.value = 1
	AudioServer.set_bus_volume_db(master_index, linear_to_db(master_slide.value))
	AudioServer.set_bus_volume_db(music_index, linear_to_db(music_slide.value))
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(sfx_slide.value))
	mute_box.button_pressed = false
	

func _on_master_slide_value_changed(value: float) -> void:
	if not mute_box.button_pressed:
		AudioServer.set_bus_volume_db(master_index, linear_to_db(value))


func _on_music_slide_value_changed(value: float) -> void:
	if not mute_box.button_pressed:
		AudioServer.set_bus_volume_db(music_index, linear_to_db(value))

func _on_sfx_slide_value_changed(value: float) -> void:
	if not mute_box.button_pressed:
		AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value))

func _on_mute_box_pressed() -> void:
	if mute_box.button_pressed:
		AudioServer.set_bus_mute(master_index, true)
		AudioServer.set_bus_mute(music_index, true)
		AudioServer.set_bus_mute(sfx_index, true)
	else:
		AudioServer.set_bus_mute(master_index, false)
		AudioServer.set_bus_mute(music_index, false)
		AudioServer.set_bus_mute(sfx_index, false)
		AudioServer.set_bus_volume_db(master_index, linear_to_db(master_slide.value))
		AudioServer.set_bus_volume_db(music_index, linear_to_db(music_slide.value))
		AudioServer.set_bus_volume_db(sfx_index, linear_to_db(sfx_slide.value))

func _on_mute_box_mouse_entered() -> void:
	hover.play()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_back_mouse_entered() -> void:
	hover.play()


func _on_reset_pressed() -> void:
	master_slide.value = 1
	music_slide.value = 1
	sfx_slide.value = 1
	mute_box.button_pressed = false
	AudioServer.set_bus_mute(master_index, false)
	AudioServer.set_bus_volume_db(master_index, linear_to_db(1))
	AudioServer.set_bus_mute(music_index, false)
	AudioServer.set_bus_volume_db(music_index, linear_to_db(1))
	AudioServer.set_bus_mute(sfx_index, false)
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(1))


func _on_reset_mouse_entered() -> void:
	hover.play()
