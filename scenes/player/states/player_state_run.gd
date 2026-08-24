extends PlayerState

func enter() -> void:
	player.sprite.play("run")

func physics_update(_delta: float) -> void:
	if left_ground():
		return
	
	var direction := Input.get_axis("left", "right")
	if direction == 0.0:
		return state_machine.transition("Idle")
	
	player.move_x(player.stats.speed)
	player.request_footsteps(2.0)
