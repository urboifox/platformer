extends PlayerState


func enter() -> void:
	player.sprite.play("teleport_out")
	player.velocity = Vector2.ZERO
	await player.sprite.animation_finished
	player.finished_level.emit()
