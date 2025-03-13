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
	var mouse_pos = get_viewport().get_mouse_position()
	var slots = GameManager.character.inventory_bar.slots
	if slots:
		for slot in slots.get_children():
			if slot.get_global_rect().has_point(mouse_pos):
				return

	if DialogueManager.is_dialogue_active:
		if current_state and current_state.name.to_lower() != "idle":
			current_state.exit()
			current_state = states["idle"]
			current_state.enter()
		return

	if new_state_name == "attack":
		var active_item = GameManager.character.inventory.get_active_item()
		if not active_item is WeaponItem:
			return

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
