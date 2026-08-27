extends PlayerState

var fall_impact_velocity := 0.0


func enter() -> void:
	_update_air_anim()


func _update_air_anim() -> void:
	var anim := "jump" if player.velocity.y < 0.0 else "fall"
	if player.sprite.animation != anim:
		player.sprite.play(anim)


func exit() -> void:
	Audio.stop("falling")
	fall_impact_velocity = 0.0


func physics_update(delta: float) -> void:
	if try_dash():
		return state_machine.transition("Dash")

	if not player.is_on_floor():
		if player.velocity.y > 0.0:
			fall_impact_velocity = player.velocity.y

	if player.is_on_floor():
		if fall_impact_velocity > 800.0:
			return state_machine.transition("Land")
		return state_machine.transition(player.land_state())

	_update_air_anim()

	if player.velocity.y > 400.0:
		Audio.play_loop("falling")

	if try_wall_slide():
		return state_machine.transition("WallSlide")

	if player.coyote_timer > 0.0 and Input.is_action_just_pressed("jump"):
		return state_machine.transition("Jump")

	if try_air_jump():
		return state_machine.transition("Jump")

	if try_attack():
		return

	player.move_x(player.stats.speed, delta)
