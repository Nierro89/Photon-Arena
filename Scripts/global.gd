extends Node

# Constants
const MAX_CPU_LEVEL := 15
const CPU_DIFFICULTIES := {
	"easy": { "reaction_time": 0.45, "max_speed": 260.0, "aim_error": 110.0, "miss_chance": 0.25 },
	"normal": { "reaction_time": 0.25, "max_speed": 350.0, "aim_error": 70.0, "miss_chance": 0.12 },
	"hard": { "reaction_time": 0.12, "max_speed": 480.0, "aim_error": 35.0, "miss_chance": 0.04 },
}
const DIFFICULTY_WEIGHTS := { "easy": 1.0, "normal": 2.0, "hard": 3.0 }
const SETTINGS_PATH := "user://settings.json"

# enums
enum GameMode { TWO_PLAYER, SINGLE_PLAYER }

# Variables
var cpu_difficulty:= "normal"
var cpu_level := 1
var new_high_score := false
var P1_Score = 0
var P2_Score = 0
var game_mode: GameMode = GameMode.TWO_PLAYER
var master_volume := 1.0
var music_volume := 1.0
var sfx_volume := 1.0
var muted := false

func _ready() -> void:
	load_settings()
	_apply_audio_settings()

func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file == null:
		return
	var data = JSON.parse_string(file.get_as_text())
	if data is Dictionary:
		master_volume = float(data.get("master_volume", 1.0))
		music_volume = float(data.get("music_volume", 1.0))
		sfx_volume = float(data.get("sfx_volume", 1.0))
		muted = bool(data.get("muted", false))
	
func save_settings() -> void:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("Could not save settings to " + SETTINGS_PATH)
		return
	file.store_string(JSON.stringify({
		"master_volume": master_volume,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"muted": muted,
	
	}))

func _apply_audio_settings() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), linear_to_db(sfx_volume))
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), muted)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), muted)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), muted)

func calculate_score() -> int:
	var weight: float = float(DIFFICULTY_WEIGHTS.get(cpu_difficulty, 1.0))
	return int(P1_Score * 100 * weight)

