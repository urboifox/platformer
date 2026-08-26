extends PlayerState


func enter() -> void:
	player.sprite.play("idle", 0.5)


func physics_update(delta: float) -> void:
	if left_ground():
		return

	var direction := Input.get_axis("left", "right")
	if direction != 0.0:
		return state_machine.transition("Run")

	if Input.is_action_just_pressed("attack"):
		return state_machine.transition("Attack")

	player.velocity.x = move_toward(player.velocity.x, 0.0, player.stats.friction * delta)
