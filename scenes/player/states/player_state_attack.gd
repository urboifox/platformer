extends PlayerState

var anim := "attack"
var slash_position := Vector2(12, 0)
var slash_rotation := 0.0
var hitbox_position := Vector2(19, 2.5)
var pogo := false


func enter() -> void:
	player.attack_cooldown = player.stats.attack_cooldown
	player.pogo_ready = pogo
	Audio.play("attack", 1.0, 3.75)
	player.aim_attack(slash_position, slash_rotation, hitbox_position)
	player.attack_sprite.visible = true
	player.sprite.play(anim, 4.0)
	player.attack_sprite.play("attack", 2.0)
	player.hitbox_shape.disabled = false
	await player.sprite.animation_finished

	if state_machine.current_state != self:
		return

	if player.is_on_floor():
		return state_machine.transition(player.ground_state())
	return state_machine.transition("Fall")


func physics_update(delta: float) -> void:
	player.move_x(player.stats.speed, delta)


func exit() -> void:
	player.pogo_ready = false
	player.hitbox_shape.disabled = true
	player.attack_sprite.visible = false
