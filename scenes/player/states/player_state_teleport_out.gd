extends PlayerState

func enter() -> void:
	player.sprite.play("teleport_out")
	await player.sprite.animation_finished
	# TODO: win
