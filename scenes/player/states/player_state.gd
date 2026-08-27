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


func try_air_jump() -> bool:
	if not Input.is_action_just_pressed("jump"):
		return false
	if player.air_jumps <= 0:
		return false
	player.air_jumps -= 1
	return true


func try_wall_slide() -> bool:
	if not player.is_on_wall():
		return false
	var wall_side = -signf(player.get_wall_normal().x)
	if signf(Input.get_axis("left", "right")) != wall_side:
		return false
	if wall_side == player.last_wall_side:
		return false
	return true


func try_attack() -> bool:
	if player.attack_cooldown > 0.0:
		return false
	if not Input.is_action_just_pressed("attack"):
		return false

	var vertical := Input.get_axis("up", "down")
	if vertical < 0.0:
		state_machine.transition("AttackUp")
	elif vertical > 0.0 and not player.is_on_floor():
		state_machine.transition("AttackDown")
	else:
		state_machine.transition("Attack")
	return true
