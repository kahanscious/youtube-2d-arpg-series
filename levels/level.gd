# level.gd
class_name Level extends Node2D

@onready var spawn_points_node: Node = $SpawnPoints

var spawn_points: Dictionary = {}


func _ready() -> void:
	LevelManager.level_setup(self)

	# Collect all spawn points from the SpawnPoints node
	if spawn_points_node:
		for spawn_point in spawn_points_node.get_children():
			if spawn_point is Marker2D:
				spawn_points[spawn_point.name] = spawn_point

	# Get the spawn point to use
	if not SceneTransition.next_spawn_point in spawn_points:
		push_error("No spawn point found with name: " + SceneTransition.next_spawn_point)
		return

	GameManager.character.global_position = (
		spawn_points[SceneTransition.next_spawn_point].global_position
	)


func _exit_tree() -> void:
	if not SceneTransition.is_transitioning:
		LevelManager.level_cleanup(self)
