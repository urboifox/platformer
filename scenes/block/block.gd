@tool
extends StaticBody2D

@export var size = Vector2(100, 20):
	set(value):
		size = value
		_update_size()

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
