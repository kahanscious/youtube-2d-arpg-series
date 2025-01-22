class_name Level extends Node2D

@onready var character_spawn: Marker2D = $CharacterSpawn


func _ready() -> void:
	LevelManager.level_setup(self)

	if not character_spawn:
		push_error("Must assign CharacterSpawn for every level!")
	GameManager.character.global_position = character_spawn.global_position


func _exit_tree() -> void:
	if not SceneTransition.is_transitioning:
		LevelManager.level_cleanup(self)
