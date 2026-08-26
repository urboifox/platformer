extends PlayerState


func enter() -> void:
	player.sprite.play("attack", 1.5)
	player.animation_player.play("attack", -1, 1.5)
	await player.sprite.animation_finished

	if state_machine.current_state != self:
		return

	if player.is_on_floor():
		return state_machine.transition(player.ground_state())
	return state_machine.transition("Fall")


func physics_update(delta: float) -> void:
	player.move_x(player.stats.speed, delta)


func exit() -> void:
	player.animation_player.stop()
	player.hitbox_shape.disabled = true
