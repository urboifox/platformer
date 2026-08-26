extends PlayerState


func enter() -> void:
	player.sprite.play("fall")


func exit() -> void:
	Audio.stop("falling")


func physics_update(delta: float) -> void:
	if try_dash():
		return state_machine.transition("Dash")

	if try_air_jump():
		return state_machine.transition("Jump")

	if player.is_on_floor():
		Audio.play("land", 0.5)
		return state_machine.transition(player.land_state())

	if player.velocity.y > 400.0:
		Audio.play_loop("falling")

	if player.is_on_wall():
		if signf(Input.get_axis("left", "right")) == player.last_wall_side:
			return state_machine.transition("WallSlide")

	if player.coyote_timer > 0.0 and Input.is_action_just_pressed("jump"):
		return state_machine.transition("Jump")

	if Input.is_action_just_pressed("attack"):
		return state_machine.transition("Attack")

	player.move_x(player.stats.speed, delta)
