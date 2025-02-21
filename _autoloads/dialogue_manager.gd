extends Node

signal dialogue_finished

var dialogue_ui_scene: PackedScene = preload("res://dialogue/dialogue_ui.tscn")
var dialogue_ui: CanvasLayer
var current_dialogue: Array = []
var dialogue_index := 0
var is_dialogue_active := false
var current_npc: NPC = null


func _enter_tree() -> void:
	dialogue_ui = dialogue_ui_scene.instantiate()
	add_child(dialogue_ui)
	dialogue_ui.hide()


func start_dialogue(dialogue_data: Array, npc: NPC = null) -> void:
	if is_dialogue_active:
		return

	current_npc = npc
	current_dialogue = dialogue_data
	dialogue_index = 0
	is_dialogue_active = true
	display_current_dialogue()


func display_current_dialogue() -> void:
	if dialogue_index >= current_dialogue.size():
		end_dialogue()
		return

	var current = current_dialogue[dialogue_index]
	dialogue_ui.show()
	dialogue_ui.show_dialogue(current)


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
		else:
			dialogue_index += 1
			display_current_dialogue()


func end_dialogue() -> void:
	is_dialogue_active = false
	dialogue_ui.hide_dialogue()
	if current_npc:
		current_npc.end_dialogue()
		current_npc = null
	dialogue_finished.emit()
