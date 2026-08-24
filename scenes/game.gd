extends Node2D

@onready var player: Player = $player
@onready var level: Node2D = $level

func _ready() -> void:
	player.spawn_position = level.get_node("spawn").global_position
	player.global_position = player.spawn_position
	
	player.camera.reset_smoothing()
