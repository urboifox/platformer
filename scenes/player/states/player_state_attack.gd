extends PlayerState


func enter() -> void:
	Audio.play("attack", 1.0, 3.75)
	player.attack_sprite.visible = true
	player.sprite.play("attack", 5.0)
	player.attack_sprite.play("attack", 5.0)
	player.hitbox_shape.disabled = false
	await player.sprite.animation_finished

	if state_machine.current_state != self:
		return

	if player.is_on_floor():
		return state_machine.transition(player.ground_state())
	return state_machine.transition("Fall")


func physics_update(delta: float) -> void:
	player.move_x(player.stats.speed, delta)


func exit() -> void:
	player.hitbox_shape.disabled = true
	player.attack_sprite.visible = false
