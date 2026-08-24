extends PlayerState

func enter() -> void:
	player.sprite.play("fall")

func exit() -> void:
	Audio.stop("falling")

func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		Audio.play("land", 0.5)
		return state_machine.transition(player.land_state())
	
	if player.coyote_timer > 0.0 and Input.is_action_just_pressed("jump"):
		return state_machine.transition("Jump")
	
	if player.velocity.y > 400.0:
		Audio.play_loop("falling")
	
	player.move_x(player.stats.walk_speed)
