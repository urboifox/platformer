extends Camera2D

@export var look_ahead: float = 40.0
@export var smooth: float = 5.0

@onready var player: Player = get_parent()

var _look_x: float = 0.0
var _shake: float = 0.0


func shake(strength: float) -> void:
	_shake = maxf(_shake, strength)


func _physics_process(delta: float) -> void:
	var target := signf(player.sprite.scale.x) * look_ahead
	_look_x = lerp(_look_x, target, smooth * delta)
	_shake = move_toward(_shake, 0.0, 60.0 * delta)
	offset = Vector2(_look_x + randf_range(-_shake, _shake), randf_range(-_shake, _shake))
