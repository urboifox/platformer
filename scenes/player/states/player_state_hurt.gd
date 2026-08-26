extends PlayerState


func enter() -> void:
	player.sprite.play("hurt")
	player.velocity.x = player.knockback_direction * player.stats.knockback_force

	await player.sprite.animation_finished
	state_machine.transition("Idle")


func physics_update(delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0.0, player.stats.knockback_friction * delta)
