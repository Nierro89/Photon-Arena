extends Area2D

@export var GoalID: int = 0
@onready var sfx_score: AudioStreamPlayer = $sfx_score

# Connects body entered signal to goal.
func _ready():
	body_entered.connect(scored)

# Searches for whether or not Ball has entered into Area2D. Increases Score of corrisponding goal.
func scored(body):
	if (body.is_in_group("ball")):
		if(GoalID == 1):
			Global.P1_Score += 1
			sfx_score.play()
		if(GoalID == 2):
			Global.P2_Score += 1
			sfx_score.play()
	
	body.queue_free()
	owner.startNextRound()
