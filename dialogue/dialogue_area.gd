class_name DialogueArea extends Area2D

signal dialogue_triggered(dialogue_set: DialogueSet)

@export var dialogue_sets: Array = []
@export var current_set_index: int = 0

var player_in_range: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body is Character:
		player_in_range = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_range:
		if not dialogue_sets.is_empty():
			var npc = get_parent() if get_parent() is NPC else null
			dialogue_triggered.emit(dialogue_sets[current_set_index], npc)
