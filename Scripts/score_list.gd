extends VBoxContainer

@onready var score_list: VBoxContainer = %ScoreList

func _ready() -> void:
	_display_scores()

func _display_scores() -> void:
	var scores: Array = HighScores.load_scores()
	for i in scores.size():
		var entry: Dictionary = scores[i]
		var row := Label.new()
		row.text = "%d. %d - %s - %s" % [
			i + 1,
			str(entry.get("name", "???")),
			int(entry["score"]),
			entry["difficulty"],
			entry["date"],
		]
		score_list.add_child(row)
