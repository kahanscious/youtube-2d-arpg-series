extends NPC

signal bridge_cleared

@export var character_name: String = "Lil John"

var has_said_yes: bool = false
var has_moved: bool = false


func _ready() -> void:
	super._ready()
	dialogue_area.dialogue_sets = [create_initial_dialogue()]

func create_initial_dialogue() -> DialogueSet:
	var set = DialogueSet.new()
	
	if has_moved:
		set.dialogues = [
			{
				"speaker": character_name,
				"text": "Hope you're finding your travels well!",
				"profile": get_profile()
			}
		]
		return set
	
	
	
	set.dialogues = [
		{
			"speaker": character_name,
			"text": "Halt! Passing this bridge will lead to lots of danger. Are you sure you want to pass?" if not has_said_yes else "Welcome back! Are you ready to pass?",
			"profile": get_profile()
		}
	]
	
	var choices = ["Yes, I'm sure!", "No, not yet."]
	DialogueUtils.add_choices_to_dialogue_set(set, choices)
	return set


func _on_dialogue_finished(choice: String):
	if not has_said_yes:
		has_said_yes = true
		dialogue_area.dialogue_sets = [create_initial_dialogue()]
		
	if choice == DialogueUtils.CHOICE_PREFIX + "0":
		var response = [
			{
				"speaker": character_name,
				"text": "I'll step aside. Good luck!",
				"profile": get_profile()
			}
		]
		DialogueManager.start_dialogue(response, self, true)
		
		if not has_moved:
			has_moved = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + Vector2(0, -32), 1.0)
			dialogue_area.dialogue_sets = [create_initial_dialogue()]
			
	elif choice == DialogueUtils.CHOICE_PREFIX + "1":
		var response = [
			{
				"speaker": character_name,
				"text": "Come back when you're ready.",
				"profile": get_profile()
			}
		]
		DialogueManager.start_dialogue(response, self, true)
