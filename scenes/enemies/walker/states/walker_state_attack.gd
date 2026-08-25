extends EnemyState

var hitbox_shape: CollisionShape2D


func enter() -> void:
	hitbox_shape = (enemy as Walker).hitbox_shape
	enemy.sprite.play("attack")


func physics_update(_delta: float) -> void:
	enemy.velocity.x = 0.0

	hitbox_shape.disabled = enemy.sprite.frame < 3

	if not enemy.sprite.is_playing():
		if enemy.target:
			return state_machine.transition("Attack")
		else:
			return state_machine.transition("Walk")


func exit() -> void:
	hitbox_shape.disabled = true
