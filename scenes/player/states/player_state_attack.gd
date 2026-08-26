extends PlayerState


func enter() -> void:
	player.sprite.play("attack")
	await player.sprite.animation_finished

	if state_machine.current_state != self:
		return

	if player.is_on_floor():
		return state_machine.transition(player.ground_state())
	return state_machine.transition("Fall")


func physics_update(delta: float) -> void:
	player.hitbox_shape.disabled = player.sprite.frame < 3 or player.sprite.frame > 5
	player.move_x(player.stats.speed, delta)


func exit() -> void:
	player.hitbox_shape.disabled = true
