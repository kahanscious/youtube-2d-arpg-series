class_name DialogueArea extends Area2D

signal dialogue_triggered(dialogue_set: DialogueSet)

@export var dialogue_sets: Array = []
@export var current_set_index: int = 0
@export var dialogue_cooldown: float = 0.2

var player_in_range: bool = false
var can_trigger := true


func _ready() -> void:
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)


func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body is Character:
		player_in_range = false


func _unhandled_input(event: InputEvent) -> void:
	var can_start_dialogue = (
		event.is_action_pressed("interact")
		and player_in_range
		and not DialogueManager.is_dialogue_active
		and can_trigger
	)

	if can_start_dialogue and not dialogue_sets.is_empty():
		var npc = get_parent() if get_parent() is NPC else null
		dialogue_triggered.emit(dialogue_sets[current_set_index], npc)


func _on_dialogue_finished(_choice: String) -> void:
	can_trigger = false
	await get_tree().create_timer(dialogue_cooldown).timeout
	can_trigger = true
