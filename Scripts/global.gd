extends Node

# Constants
const MAX_CPU_LEVEL := 10
const CPU_DIFFICULTIES := {
	"easy": { "reaction_time": 0.45, "max_speed": 260.0, "aim_error": 110.0, "miss_chance": 0.25 },
	"normal": { "reaction_time": 0.25, "max_speed": 350.0, "aim_error": 70.0, "miss_chance": 0.12 },
	"hard": { "reaction_time": 0.12, "max_speed": 480.0, "aim_error": 35.0, "miss_chance": 0.04 },
}
const DIFFICULTY_WEIGHTS := { "easy": 1.0, "normal": 2.0, "hard": 3.0 }

# enums
enum GameMode { TWO_PLAYER, SINGLE_PLAYER }

# Variables
var cpu_difficulty:= "normal"
var cpu_level := 1
var new_high_score := false
var P1_Score = 0
var P2_Score = 0
var game_mode: GameMode = GameMode.TWO_PLAYER

func calculate_score() -> int:
	var weight: float = float(DIFFICULTY_WEIGHTS.get(cpu_difficulty, 1.0))
	return int(P1_Score * 100 * weight)

