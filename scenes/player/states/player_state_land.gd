extends PlayerState


func enter() -> void:
	player.velocity = Vector2.ZERO
	Audio.play("land", 0.5)

	player.sprite.play("land")
	_pause_on_frame()

	await player.sprite.animation_finished
	state_machine.transition(player.ground_state())


func _pause_on_frame() -> void:
	while player.sprite.frame < 1:
		await get_tree().process_frame

	player.sprite.pause()

	await get_tree().create_timer(0.3).timeout

	player.sprite.play()
