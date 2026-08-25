extends Camera2D

@export var look_ahead: float = 40.0
@export var smooth: float = 5.0

@onready var player: Player = get_parent()


func _physics_process(delta: float) -> void:
	var target := signf(player.sprite.scale.x) * look_ahead
	offset.x = lerp(offset.x, target, smooth * delta)
