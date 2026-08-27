extends Node

const SOUNDS := {
	"footsteps": preload("res://assets/audio/sfx_footsteps.wav"),
	"jump": preload("res://assets/audio/sfx_jump.wav"),
	"falling": preload("res://assets/audio/sfx_falling.wav"),
	"land": preload("res://assets/audio/sfx_land.wav"),
	"coin": preload("res://assets/audio/sfx_coin.ogg"),
	"attack": preload("res://assets/audio/sfx_attack_1.wav"),
}

var _loops: Dictionary = { }
var _players: Array[AudioStreamPlayer] = []
var _index := 0


func _ready() -> void:
	for i in 8:
		var player := AudioStreamPlayer.new()
		player.bus = &"SFX"
		add_child(player)
		_players.append(player)


func play(sound: String, volume := 1.0, speed := 1.0, pitch_variation := 0.2) -> void:
	var player := _players[_index]
	_index = (_index + 1) % _players.size()
	player.stream = SOUNDS[sound]
	player.volume_db = linear_to_db(volume)
	player.pitch_scale = speed + randf_range(-pitch_variation, pitch_variation)
	player.play()


func play_loop(sound: String, volume := 1.0, speed := 1.0) -> void:
	var player: AudioStreamPlayer = _loops.get(sound)
	if player == null:
		player = AudioStreamPlayer.new()
		player.stream = SOUNDS[sound]
		player.bus = &"SFX"
		add_child(player)
		_loops[sound] = player
	player.volume_db = linear_to_db(volume)
	player.pitch_scale = speed
	if not player.playing:
		player.play()


func stop(sound: String) -> void:
	if _loops.has(sound):
		_loops[sound].stop()
