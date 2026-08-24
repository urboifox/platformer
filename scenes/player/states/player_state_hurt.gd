extends PlayerState

func enter() -> void:
	player.sprite.play("hurt")
	
	var direction := Input.get_axis("left", "right")
	player.velocity.x = -direction * player.stats.knockback_force
	
	await player.sprite.animation_finished
	state_machine.transition("Idle")

func physics_update(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0.0, player.stats.friction * delta)
