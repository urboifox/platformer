class_name StateMachine
extends Node

@export var initial_state: State

var _states: Dictionary = { }
var current_state: State

signal state_changed(from: State, to: State)


func _ready() -> void:
	for child in get_children():
		if child is State:
			child.state_machine = self
			_states[child.name] = child


func start() -> void:
	current_state = initial_state
	if current_state:
		current_state.enter()


func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func transition(new_state: String) -> void:
	var next: State = _states.get(new_state)
	if next == null:
		push_warning("StateMachine: no state named '%s'" % new_state)
		return

	var previous_state := current_state
	if previous_state:
		previous_state.exit()

	current_state = next
	current_state.enter()
	state_changed.emit(previous_state, current_state)
