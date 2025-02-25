extends CanvasLayer

@onready var dialogue_box: PanelContainer = $DialogueBox
@onready
var text: Label = $DialogueBox/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Text
@onready
var profile: TextureRect = $DialogueBox/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Profile
@onready
var speaker_name: Label = $DialogueBox/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/SpeakerName
@onready
var choice_container: HBoxContainer = $DialogueBox/MarginContainer/VBoxContainer/ChoiceContainer
@onready
var separator: HSeparator = $DialogueBox/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSeparator

var typing_speed := 0.05
var is_typing: bool = false
var full_text: String = ""
var pending_choices: Array = []


func show_dialogue(current: Dictionary) -> void:
	dialogue_box.show()
	clear_choices()

	speaker_name.text = current.speaker
	full_text = current.text
	text.text = ""

	if current.has("profile"):
		profile.texture = current.profile
		profile.show()
	else:
		profile.hide()

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
	show_pending_choices()


func hide_dialogue() -> void:
	dialogue_box.hide()
	clear_choices()


func show_choices(choices: Array) -> void:
	pending_choices = choices
	if not is_typing:
		show_pending_choices()


func show_pending_choices() -> void:
	if pending_choices.is_empty():
		return

	separator.show()
	for choice in pending_choices:
		_create_choice_button(choice.text, choice.choice_id)
	pending_choices.clear()


func _create_choice_button(choice_text: String, choice_id: String) -> void:
	var button := Button.new()
	button.text = choice_text
	button.pressed.connect(func(): _on_choice_selected(choice_id))
	choice_container.add_child(button)


func _on_choice_selected(choice_id: String) -> void:
	DialogueManager.current_choice = choice_id
	DialogueManager.dialogue_index += 1
	DialogueManager.display_current_dialogue()


func clear_choices() -> void:
	for child in choice_container.get_children():
		child.queue_free()
	separator.hide()
	pending_choices.clear()
