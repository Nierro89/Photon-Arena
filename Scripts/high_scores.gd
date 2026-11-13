extends Node

const SAVE_PATH := "user://highscores.json"
const MAX_ENTRIES := 10

func record_score(entry: Dictionary) -> void:
	var scores := load_scores()
	entry["date"] = Time.get_date_string_from_system()
	scores.append(entry)
	scores.sort_custom(func(a, b): return a["score"] > b["score"])
	while scores.size() > MAX_ENTRIES:
		scores.pop_back()
	save_scores(scores)

func load_scores() -> Array:
	if not FileAccess.file_exists(SAVE_PATH):
		return[]
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return[]
	var data = JSON.parse_string(file.get_as_text())
	if data is Array:
		return data
	return[]

func save_scores(scores: Array) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("Could not save high scores to " + SAVE_PATH)
		return
	file.store_string(JSON.stringify(scores))

