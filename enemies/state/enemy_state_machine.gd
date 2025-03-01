class_name EnemyStateMachine extends Node

var current_state: EnemyState = null
var states: Dictionary = {}


func _ready() -> void:
	await owner.ready

	for child in get_children():
		if child is EnemyState:
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
