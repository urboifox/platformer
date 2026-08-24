@tool
extends Area2D

@export var size = Vector2(100, 20):
	set(value):
		size = value
		_update_size()
@export var damage: float = 1.0

@onready var rect: ColorRect = $ColorRect
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision.shape = collision.shape.duplicate()
	_update_size()
	
func _update_size() -> void:
	if not is_node_ready():
		return
	collision.shape.size = size
	rect.size = size
	rect.position = -size / 2

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	for area in get_overlapping_areas():
		if area.owner.has_method("take_damage"):
			area.owner.take_damage(damage, global_position)
