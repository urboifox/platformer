extends PlayerState


func enter() -> void:
	player.sprite.play("run", 1.5)


func physics_update(delta: float) -> void:
	if try_dash():
		return state_machine.transition("Dash")

	if left_ground():
		return

	var direction := Input.get_axis("left", "right")
	if direction == 0.0:
		return state_machine.transition("Idle")

	if try_attack():
		return

	player.move_x(player.stats.speed, delta)
	player.request_footsteps(2.0)
