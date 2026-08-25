extends PlayerState


func enter() -> void:
	player.sprite.play("die")
	player.velocity = Vector2.ZERO

	await player.sprite.animation_finished
	player.respawn()
	state_machine.transition("TeleportIn")
