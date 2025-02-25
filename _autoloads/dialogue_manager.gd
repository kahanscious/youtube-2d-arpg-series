extends Node

signal dialogue_finished(choice: String)

var dialogue_ui_scene: PackedScene = preload("res://dialogue/dialogue_ui.tscn")
var dialogue_ui: CanvasLayer
var current_dialogue: Array = []
var dialogue_index := 0
var is_dialogue_active := false
var current_npc: NPC = null
var current_choice: String = ""
var waiting_for_input := false
var is_choice_response := false
var dialogue_cooldown := 0.2


func _enter_tree() -> void:
	dialogue_ui = dialogue_ui_scene.instantiate()
	add_child(dialogue_ui)
	dialogue_ui.hide()


func start_dialogue(dialogue_data: Array, npc: NPC = null, is_response := false) -> void:
	if is_dialogue_active:
		return

	current_npc = npc
	current_dialogue = dialogue_data
	dialogue_index = 0
	is_dialogue_active = true
	is_choice_response = is_response
	display_current_dialogue()


func display_current_dialogue() -> void:
	if dialogue_index >= current_dialogue.size():
		end_dialogue()
		return

	dialogue_ui.show()
	dialogue_ui.show_dialogue(current_dialogue[dialogue_index])

	if is_choice_response:
		waiting_for_input = true
		return

	var choices := []
	dialogue_index += 1

	while dialogue_index < current_dialogue.size():
		var next = current_dialogue[dialogue_index]
		if DialogueUtils.is_choice_dialogue(next):
			choices.append(next)
			dialogue_index += 1
		else:
			break

	if not choices.is_empty():
		dialogue_ui.show_choices(choices)
		waiting_for_input = false
	else:
		waiting_for_input = true


func _input(event: InputEvent) -> void:
	if not is_dialogue_active:
		return

	if (
		(event is InputEventKey and event.pressed)
		or (event is InputEventMouseButton and event.pressed)
	):
		if dialogue_ui.is_typing:
			dialogue_ui.is_typing = false
			dialogue_ui.text.text = dialogue_ui.full_text
			dialogue_ui.show_pending_choices()
		elif waiting_for_input:
			end_dialogue()
			waiting_for_input = false


func end_dialogue() -> void:
	dialogue_ui.hide()
	is_dialogue_active = true
	dialogue_finished.emit(current_choice)
	current_choice = ""

	await get_tree().create_timer(dialogue_cooldown).timeout
	is_dialogue_active = false
