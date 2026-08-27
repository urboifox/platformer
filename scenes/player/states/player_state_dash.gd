extends PlayerState

var _timer: float = 0.0


func enter() -> void:
	player.sprite.play("dash")
	player.apply_gravity = false

	_timer = player.stats.dash_time
	player.velocity.y = 0.0


func exit() -> void:
	player.apply_gravity = true


func physics_update(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0 or player.is_on_wall():
		if player.is_on_floor():
			return state_machine.transition(player.ground_state())
		return state_machine.transition("Fall")

	if try_attack():
		return

	player.dash_x(player.stats.dash_speed, delta)
