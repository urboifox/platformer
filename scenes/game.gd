extends Node2D

@export var levels: Array[PackedScene]

@onready var player: Player = $player
@onready var level_container: Node2D = $LevelContainer

var _level: Node2D
var _index := 0

func _ready() -> void:
	player.finished_level.connect(_on_finished_level)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	load_level(0)

func load_level(index: int) -> void:
	if index >= levels.size() or levels[index] == null:
		push_warning("LevelManager: level '%s' was not found" % (_index + 1))
		return
	if _level:
		_level.queue_free()
	
	_index = index
	_level = levels[_index].instantiate()
	level_container.add_child(_level)
	player.spawn_position = _level.get_node("spawn").global_position
	player.global_position = player.spawn_position
	player.camera.reset_smoothing()
	player.state_machine.transition("TeleportIn")

func _on_finished_level() -> void:
	var next_level_index := (_index + 1) % levels.size()
	# TODO: if it's the last level do something
	load_level(next_level_index)
