extends EnemyState

func enter() -> void:
	enemy.sprite.play("walk")

func physics_update(_delta: float) -> void:
	var walker := enemy as Walker
	if walker.wall_check.is_colliding() or not walker.ground_check.is_colliding():
		flip_direction()
	
	enemy.velocity.x = enemy.direction * enemy.speed
	
	if enemy.target:
		state_machine.transition("Attack")

func flip_direction() -> void:
	enemy.direction = -enemy.direction
	enemy.sprite.scale.x = -enemy.direction
