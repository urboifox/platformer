extends "res://scenes/player/states/player_state_attack.gd"


func _init() -> void:
	anim = "attack_down"
	slash_position = Vector2(0, 16)
	slash_rotation = PI / 2
	hitbox_position = Vector2(0, 24)
	pogo = true
