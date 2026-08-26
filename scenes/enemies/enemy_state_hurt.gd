extends EnemyState


func enter() -> void:
	enemy.velocity.x = enemy.knockback_direction * enemy.knockback_force


func physics_update(delta: float) -> void:
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, enemy.knockback_friction * delta)
	if is_zero_approx(enemy.velocity.x):
		state_machine.transition(state_machine.initial_state.name)
