extends NPC

signal bridge_cleared

@export var move_position: Vector2
@export var character_name: String = "Lil John"

var has_said_yes: bool = false


func _ready() -> void:
	super._ready()

	dialogue_area.dialogue_sets = [create_initial_dialogue()]

func create_initial_dialogue() -> DialogueSet:
	var set = DialogueSet.new()
	set.dialogues = [
		{
			"speaker": character_name,
			"text": "Halt! You cannot pass this bridge. It is too dangerous!"
		}
	]
	return set


func _on_dialogue_finished(choice: String):
	if choice == "yes" and not has_said_yes:
		has_said_yes = true
