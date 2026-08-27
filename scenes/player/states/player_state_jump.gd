extends PlayerState


func enter() -> void:
	Audio.play("jump", 0.5)
	player.sprite.play("jump")
	player.velocity.y = player.stats.jump_velocity
	player.coyote_timer = 0.0
	player.jump_buffer = 0.0


func physics_update(delta: float) -> void:
	if try_dash():
		return state_machine.transition("Dash")

	if player.is_on_floor():
		return state_machine.transition(player.land_state())

	if player.velocity.y > player.stats.fall_threshold:
		return state_machine.transition("Fall")

	if Input.is_action_just_released("jump") and player.velocity.y < 0.0:
		player.velocity.y *= player.stats.jump_cut

	if try_attack():
		return

	if try_wall_slide():
		return state_machine.transition("WallSlide")

	if try_air_jump():
		return state_machine.transition("Jump")

	player.move_x(player.stats.speed, delta)
