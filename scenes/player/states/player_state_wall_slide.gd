extends PlayerState


func enter() -> void:
	player.sprite.play("wall_slide")
	player.apply_gravity = false
	player.last_wall_side = -signf(player.get_wall_normal().x)


func exit() -> void:
	player.apply_gravity = true


func physics_update(delta: float) -> void:
	if not player.is_on_wall() or not player.wall_check.is_colliding():
		return state_machine.transition("Fall")

	if Input.is_action_just_pressed("jump"):
		return state_machine.transition("Jump")

	if signf(Input.get_axis("left", "right")) != player.last_wall_side:
		return state_machine.transition("Fall")

	if player.is_on_floor():
		return state_machine.transition(player.ground_state())

	player.velocity.y = player.stats.wall_slide_velocity
	player.coyote_timer = player.stats.coyote_time
	player.move_x(player.stats.speed, delta)
