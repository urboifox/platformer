extends PlayerState


func enter() -> void:
	player.sprite.play("die")
	player.velocity = Vector2.ZERO
	player.juice(0.1, 8.0)

	await player.sprite.animation_finished
	player.respawn()
	state_machine.transition("TeleportIn")
