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
	master_slide.value = Global.master_volume
	music_slide.value = Global.music_volume
	sfx_slide.value = Global.sfx_volume
	mute_box.button_pressed = Global.muted

	master_slide.value_changed.connect(_on_master_slide_value_changed)
	music_slide.value_changed.connect(_on_music_slide_value_changed)
	sfx_slide.value_changed.connect(_on_sfx_slide_value_changed)
	mute_box.pressed.connect(_on_mute_box_pressed)
	reset.pressed.connect(_on_reset_pressed)
	

func _on_master_slide_value_changed(value: float) -> void:
	Global.master_volume = value
	AudioServer.set_bus_volume_db(master_index, linear_to_db(value))
	Global.save_settings()

func _on_music_slide_value_changed(value: float) -> void:
	Global.music_volume = value
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value))
	Global.save_settings()

func _on_sfx_slide_value_changed(value: float) -> void:
	Global.sfx_volume = value
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value))
	Global.save_settings()

func _on_mute_box_pressed() -> void:
	Global.muted = mute_box.button_pressed
	Global._apply_audio_settings()
	Global.save_settings()

func _on_mute_box_mouse_entered() -> void:
	hover.play()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_back_mouse_entered() -> void:
	hover.play()


func _on_reset_pressed() -> void:
	Global.master_volume = 1.0
	Global.music_volume = 1.0
	Global.sfx_volume = 1.0
	Global.muted = false

	master_slide.value = 1.0
	music_slide.value = 1.0
	sfx_slide.value = 1.0
	mute_box.button_pressed = false

	Global._apply_audio_settings()
	Global.save_settings()

func _on_reset_mouse_entered() -> void:
	hover.play()
