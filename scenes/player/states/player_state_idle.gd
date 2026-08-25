extends PlayerState


func enter() -> void:
	player.sprite.play("idle")
	player.velocity.x = 0.0


func physics_update(delta: float) -> void:
	if left_ground():
		return

	var direction := Input.get_axis("left", "right")
	if direction != 0.0:
		return state_machine.transition("Run")
