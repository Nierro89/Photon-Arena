extends MarginContainer

@onready var score_list: VBoxContainer = %ScoreList

func _ready() -> void:
	_display_scores()
	_setup_name_entry()

func _setup_name_entry() -> void:
	if Global.game_mode != Global.GameMode.SINGLE_PLAYER:
		return
	var scores: Array = HighScores.load_scores()
	var qualifies: bool = scores.size() < HighScores.MAX_ENTRIES \
		or int(Global.P1_Score) > int(scores[HighScores.MAX_ENTRIES - 1]["score"])
	%NameInput.visible = qualifies
	%SaveButton.visible = qualifies
	%PromptLabel.visible = qualifies

func _on_save_button_pressed() -> void:
	var player_name: String = %NameInput.text.strip_edges().to_upper()
	if player_name.is_empty():
		player_name = "PLAYER"
	HighScores.record_score({
	"name": player_name,
	"score": Global.calculate_score(),
	"difficulty": Global.cpu_difficulty,
	"level": Global.cpu_level,
	"date":Time.get_date_string_from_system(),
	})
	%NameInput.visible = false
	%SaveButton.visible = false
	%PromptLabel.visible = false
	_display_scores()

func _display_scores() -> void:
	for child in score_list.get_children():
		child.queue_free()
	var scores: Array = HighScores.load_scores()
	for i in scores.size():
		var entry: Dictionary = scores[i]
		var row := Label.new()
		row.text = "%d. %s - %d - %s - %s" % [
		i + 1,
		str(entry.get("name", "???")),
		int(entry["score"]),
		entry["difficulty"],
		entry["date"],
		]
		score_list.add_child(row)
