extends StaticBody2D

const TEXTURE_INTACT := preload("res://Sprites/crate.svg")
const TEXTURE_CRACKED := preload("res://Sprites/crate_cracked.svg")

@export var hits_to_break := 2

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var sfx_hit: AudioStreamPlayer = $sfx_hit

var hits_left: int

func _ready() -> void:
	hits_left = hits_to_break
	sprite.texture = TEXTURE_INTACT
	hitbox.body_entered.connect(_on_hit)

func _on_hit(body: Node2D) -> void:
	if not body.is_in_group("ball"):
		return
	hits_left -= 1
	if hits_left <= 0:
		queue_free()
		return
	sfx_hit.play()
	sprite.texture = TEXTURE_CRACKED
