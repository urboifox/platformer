class_name Player
extends CharacterBody2D

@export var stats: MovementStats

@onready var camera: Camera2D = $Camera2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

var hp: float
var spawn_position: Vector2
var coyote_timer: float = 0.0
var jump_buffer: float = 0.0
var invincible_timer: float = 0.0
var _footstep_grace: float = 0.0

signal finished_level()

func _ready() -> void:
	hp = stats.health
	state_machine.start()

func _physics_process(delta: float) -> void:
	_update_timers(delta)
	_update_invincibility(delta)
	state_machine.physics_update(delta)
	_update_footsteps(delta)
	
	if not is_on_floor():
		var gravity := stats.gravity * (stats.fall_multiplier if velocity.y > 0.0 else 1.0)
		velocity.y += gravity * delta

	move_and_slide()

func face(direction: float) -> void:
	if direction != 0.0:
		sprite.scale.x = -1 if direction < 0.0 else 1

func move_x(speed: float) -> void:
	var direction := Input.get_axis("left", "right")
	face(direction)
	velocity.x = direction * speed

func ground_state() -> String:
	if Input.get_axis("left", "right") == 0.0:
		return "Idle"
	if Input.is_action_pressed("run"):
		return "Run"
	return "Walk"

func land_state() -> String:
	return "Jump" if jump_buffer > 0.0 else ground_state()

func air_speed() -> float:
	return stats.run_speed if Input.is_action_pressed("run") else stats.walk_speed

func _update_timers(delta: float) -> void:
	coyote_timer = stats.coyote_time if is_on_floor() else coyote_timer - delta
	jump_buffer = stats.jump_buffer_time if Input.is_action_just_pressed("jump") else jump_buffer - delta

func damage(strength: float) -> void:
	if invincible_timer > 0.0:
		return
	hp -= strength
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
	camera.reset_smoothing()

func win() -> void:
	state_machine.transition("Win")
