class_name DialogueUtils extends RefCounted

const CHOICE_PREFIX: String = "choice_"


static func add_choices_to_dialogue_set(dialogue_set: DialogueSet, choices: Array):
	for i in range(choices.size()):
		dialogue_set.dialogues.append(
			{"speaker": "choice", "text": choices[i], "choice_id": CHOICE_PREFIX + str(i)}
		)


static func is_choice_dialogue(dialogue: Dictionary) -> bool:
	return dialogue.get("speaker") == "choice"


static func get_choice_id(dialogue: Dictionary) -> String:
	return dialogue.get("choice_id", "")
