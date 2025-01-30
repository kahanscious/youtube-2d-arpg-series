class_name Level extends Node2D

@onready var spawn_points_node: Node = $SpawnPoints

var spawn_points: Dictionary = {}


func _ready() -> void:
	LevelManager.level_setup(self)

	if spawn_points_node:
		for spawn_point in spawn_points_node.get_children():
			if spawn_point is Marker2D:
				spawn_points[spawn_point.name] = spawn_point

	for child in get_children():
		if child is Enemy and not GameState.is_enemy_defeated(child.enemy_id):
			child.died.connect(_on_enemy_died.bind(child))
		elif child is Enemy and GameState.is_enemy_defeated(child.enemy_id):
			child.queue_free()

	if not SceneTransition.next_spawn_point in spawn_points:
		push_error("No spawn point found with name: " + SceneTransition.next_spawn_point)
		return

	GameManager.character.global_position = (
		spawn_points[SceneTransition.next_spawn_point].global_position
	)


func _exit_tree() -> void:
	if not SceneTransition.is_transitioning:
		LevelManager.level_cleanup(self)


func get_spawn_point() -> Node2D:
	if not spawn_points_node:
		push_error("No spawn points node found!")
		return null

	if not SceneTransition.next_spawn_point in spawn_points:
		push_error("No spawn point found with name: " + SceneTransition.next_spawn_point)
		return null

	return spawn_points[SceneTransition.next_spawn_point]


func add_character_at_spawn(spawn_point: Node2D) -> void:
	if GameManager.character.get_parent():
		GameManager.character.get_parent().remove_child(GameManager.character)
	add_child(GameManager.character)
	GameManager.character.global_position = spawn_point.global_position


func _on_enemy_died(enemy: Enemy) -> void:
	if enemy.enemy_id:
		GameState.mark_enemy_defeated(enemy.enemy_id)
