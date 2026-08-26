extends CanvasLayer

@export var hearts_spacing: float = 16.0

const HEART = preload("res://scenes/hud/heart.tscn")

@onready var hearts: Node2D = $Hearts


func setup(total_hearts: int) -> void:
	for i in total_hearts:
		var heart := HEART.instantiate()
		heart.position.x = hearts_spacing * i
		hearts.add_child(heart)


func update_health(current_health: float) -> void:
	for i in hearts.get_child_count():
		var heart := hearts.get_child(i) as AnimatedSprite2D
		heart.play("filled" if i < current_health else "empty")
