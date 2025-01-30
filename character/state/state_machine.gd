class_name StateMachine extends Node

var current_state: State = null
var states: Dictionary = {}
# {"idle": IdleState}


func _ready() -> void:
	await owner.ready

	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self

	if states.has("idle"):
		change_state("idle")


func change_state(new_state_name: String) -> void:
	if current_state:
		current_state.exit()

	if states.has(new_state_name):
		current_state = states[new_state_name]
		current_state.enter()
	else:
		printerr("State ", new_state_name, " not found!")


func physics_update(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func handle_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)


func transition_to(new_state: String) -> void:
	if states.has(new_state):
		if current_state:
			current_state.exit()
		current_state = states[new_state]
		current_state.enter()
	else:
		printerr("State ", new_state, " not found!")
