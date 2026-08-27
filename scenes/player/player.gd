class_name Player
extends CharacterBody2D

@export var stats: MovementStats

@onready var camera: Camera2D = $Camera2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_sprite: AnimatedSprite2D = $AnimatedSprite2D/AttackAnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var wall_check: RayCast2D = $AnimatedSprite2D/WallCheck # used to check if the player reached the end of the wall he is sliding on
@onready var hitbox_shape: CollisionShape2D = $AnimatedSprite2D/hitbox/CollisionShape2D

var hp: float
var spawn_position: Vector2
var coyote_timer: float = 0.0
var jump_buffer: float = 0.0
var invincible_timer: float = 0.0
var _footstep_grace: float = 0.0
var knockback_direction: float = 0.0
var apply_gravity: bool = true
var last_wall_side: float = 0.0 # used for wall slide
var air_dashes: int
var air_jumps: int
var attack_cooldown: float = 0.0
var pogo_ready: bool = false
var finishing: bool = false

signal finished_level()
signal health_changed(value: float)


func _ready() -> void:
	hp = stats.health
	health_changed.emit(hp)
	air_dashes = stats.air_dashes
	air_jumps = stats.air_jumps
	state_machine.start()


func _physics_process(delta: float) -> void:
	_update_timers(delta)
	_update_invincibility(delta)
	state_machine.physics_update(delta)
	_update_footsteps(delta)

	if not is_on_floor() and apply_gravity:
		var gravity := stats.gravity * (
			stats.fall_multiplier if velocity.y > 0.0 and not Input.is_action_pressed("jump") else 1.0
		)
		velocity.y += gravity * delta

	if is_on_floor():
		air_dashes = stats.air_dashes
		air_jumps = stats.air_jumps
		last_wall_side = -signf(wall_check.get_collision_normal().x) if wall_check.is_colliding() else 0.0

	move_and_slide()


func face(direction: float) -> void:
	if direction != 0.0:
		sprite.scale.x = -1 if direction < 0.0 else 1


func aim_attack(slash_position: Vector2, slash_rotation: float, hitbox_position: Vector2) -> void:
	attack_sprite.position = slash_position
	attack_sprite.rotation = slash_rotation * signf(sprite.scale.x)
	hitbox_shape.position = hitbox_position


func move_x(speed: float, delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	face(direction)
	velocity.x = move_toward(velocity.x, direction * speed, stats.acceleration * delta)


func dash_x(speed: float, delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction == 0.0:
		direction = signf(sprite.scale.x)
	face(direction)
	velocity.x = move_toward(velocity.x, direction * speed, stats.acceleration * delta)


func ground_state() -> String:
	return "Idle" if Input.get_axis("left", "right") == 0.0 else "Run"


func land_state() -> String:
	return "Jump" if jump_buffer > 0.0 else ground_state()


func _update_timers(delta: float) -> void:
	coyote_timer = stats.coyote_time if is_on_floor() else coyote_timer - delta
	jump_buffer = stats.jump_buffer_time if Input.is_action_just_pressed("jump") else jump_buffer - delta
	if attack_cooldown > 0.0:
		attack_cooldown -= delta


func juice(duration := 0.08, strength := 6.0) -> void:
	camera.shake(strength)
	Engine.time_scale = 0.0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0


func on_attack_hit() -> void:
	if pogo_ready:
		pogo()


func pogo() -> void:
	pogo_ready = false
	velocity.y = stats.pogo_force
	air_jumps = stats.air_jumps
	air_dashes = stats.air_dashes
	state_machine.call_deferred("transition", "Fall")


func take_damage(damage: float, source_position: Vector2) -> void:
	if invincible_timer > 0.0 or hp <= 0.0:
		return
	hp -= damage
	health_changed.emit(hp)
	knockback_direction = signf(global_position.x - source_position.x)
	if knockback_direction == 0.0:
		knockback_direction = -signf(sprite.scale.x)
	juice(0.1, 8.0)
	if hp <= 0.0:
		state_machine.transition("Die")
		return
	invincible_timer = stats.invincible_time
	state_machine.transition("Hurt")


func _update_invincibility(delta: float) -> void:
	if invincible_timer <= 0.0:
		return
	invincible_timer -= delta
	if invincible_timer <= 0.0:
		sprite.modulate.a = 1.0
	else:
		sprite.modulate.a = 0.55 + 0.45 * sin(invincible_timer * 25.0)


func request_footsteps(speed: float) -> void:
	_footstep_grace = 0.08
	Audio.play_loop("footsteps", 1.0, speed)


func _update_footsteps(delta: float) -> void:
	if _footstep_grace > 0.0:
		_footstep_grace -= delta
		if _footstep_grace <= 0.0:
			Audio.stop("footsteps")


func respawn() -> void:
	global_position = spawn_position
	hp = stats.health
	health_changed.emit(hp)
	invincible_timer = stats.invincible_time
	camera.reset_smoothing()


func finish_level() -> void:
	finished_level.emit()


func win() -> void:
	if finishing:
		return
	finishing = true
	state_machine.transition("Win")
