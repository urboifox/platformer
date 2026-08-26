class_name Enemy
extends CharacterBody2D

@export var speed: float = 80.0
@export var gravity: float = 1400.0
@export var hp: float = 3.0
@export_enum("right", "left") var facing: String = "right"
@export var knockback_force: float = 300.0
@export var knockback_friction: float = 1200.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine

var direction: int
var target: Node2D = null
var knockback_direction: float = 0.0


func _on_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body


func _on_detector_body_exited(body: Node2D) -> void:
	if body == target:
		target = null


func _ready() -> void:
	if sprite.has_node("Detector"):
		var detector = sprite.get_node("Detector")
		detector.body_entered.connect(_on_detector_body_entered)
		detector.body_exited.connect(_on_detector_body_exited)

	direction = 1 if facing == "right" else -1
	state_machine.start()


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)

	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


func take_damage(damage: float, source_position: Vector2) -> void:
	hp -= damage
	if hp <= 0.0:
		die()
		return
	knockback_direction = signf(global_position.x - source_position.x)
	state_machine.transition("Hurt")


func die() -> void:
	queue_free()
