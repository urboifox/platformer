extends PlayerState

func enter() -> void:
	player.velocity = Vector2.ZERO
	player.sprite.play("teleport_in")
	await player.sprite.animation_finished
	state_machine.transition("Idle")
