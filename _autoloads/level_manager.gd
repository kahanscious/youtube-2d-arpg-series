extends Node

signal level_load_started
signal level_load_finished

const STARTING_LEVEL_PATH: String = "res://levels/test_level.tscn"

var current_level: Level


func _ready() -> void:
	SceneTransition.transition_started.connect(_on_transition_started)
	SceneTransition.transition_finished.connect(_on_transition_finished)


func _on_transition_started() -> void:
	print("Transition started")
	if is_instance_valid(current_level) and GameManager.character.get_parent():
		GameManager.character.get_parent().remove_child(GameManager.character)


func _on_transition_finished() -> void:
	print("Transition finished")
	await get_tree().process_frame
	GameManager.character.camera.setup_camera_limits()
	level_load_finished.emit()


func level_setup(level: Level) -> void:
	print("Setting up level: ", level.name)
	current_level = level
	if GameManager.character.get_parent():
		GameManager.character.get_parent().remove_child(GameManager.character)
	current_level.add_child(GameManager.character)
	print("Setting up camera limits for: ", level.name)
	GameManager.character.camera.setup_camera_limits()
	level_load_started.emit()


func level_cleanup(level: Level) -> void:
	print("Cleaning up level: ", level.name)
	if level == current_level:
		current_level = null
