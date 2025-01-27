# level.gd
class_name Level extends Node2D

@onready var spawn_points_node: Node = $SpawnPoints

var spawn_points: Dictionary = {}


func _ready() -> void:
	LevelManager.level_setup(self)

<<<<<<< Updated upstream
	# Collect all spawn points from the SpawnPoints node
=======
>>>>>>> Stashed changes
	if spawn_points_node:
		for spawn_point in spawn_points_node.get_children():
			if spawn_point is Marker2D:
				spawn_points[spawn_point.name] = spawn_point

<<<<<<< Updated upstream
	# Get the spawn point to use
	if not SceneTransition.next_spawn_point in spawn_points:
		push_error("No spawn point found with name: " + SceneTransition.next_spawn_point)
		return

=======
	if not SceneTransition.next_spawn_point in spawn_points:
		push_error("No spawn point fround with the name: ", SceneTransition.next_spawn_point)
		return
>>>>>>> Stashed changes
	GameManager.character.global_position = (
		spawn_points[SceneTransition.next_spawn_point].global_position
	)


func _exit_tree() -> void:
	if not SceneTransition.is_transitioning:
		LevelManager.level_cleanup(self)
