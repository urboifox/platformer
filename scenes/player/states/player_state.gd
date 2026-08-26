@abstract
class_name PlayerState
extends State

@onready var player: Player = owner as Player


func left_ground() -> bool:
	if not player.is_on_floor():
		state_machine.transition("Fall")
		return true
	if Input.is_action_just_pressed("jump"):
		state_machine.transition("Jump")
		return true
	return false


func try_dash() -> bool:
	if not Input.is_action_just_pressed("dash"):
		return false

	if not player.is_on_floor() or player.is_on_wall():
		if player.air_dashes <= 0:
			return false
		player.air_dashes -= 1

	return true
