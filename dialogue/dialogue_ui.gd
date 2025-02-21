extends CanvasLayer

@onready var dialogue_box: PanelContainer = $DialogueBox
@onready
var speaker_name: Label = $DialogueBox/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/SpeakerName
@onready
var text: Label = $DialogueBox/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Text

var typing_speed := 0.05
var is_typing: bool = false
var full_text: String = ""


func show_dialogue(current: Dictionary) -> void:
	dialogue_box.show()
	speaker_name.text = current.speaker
	full_text = current.text
	text.text = ""
	start_typing()


func start_typing() -> void:
	is_typing = true
	var display_length := 0

	while display_length < full_text.length() and is_typing:
		text.text = full_text.substr(0, display_length + 1)
		display_length += 1
		await get_tree().create_timer(typing_speed).timeout

	is_typing = false
	text.text = full_text


func hide_dialogue() -> void:
	dialogue_box.hide()
