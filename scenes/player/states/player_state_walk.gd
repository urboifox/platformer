extends PlayerState

func enter() -> void:
	player.sprite.play("walk")

func physics_update(_delta: float) -> void:
	if left_ground():
		return
	
	var direction := Input.get_axis("left", "right")
	if direction == 0.0:
		return state_machine.transition("Idle")
	if Input.is_action_pressed("run"):
		return state_machine.transition("Run")
	
	player.move_x(player.stats.walk_speed)
	player.request_footsteps(1.5)
