extends Node

var defeated_enemies: Dictionary = {}


func is_enemy_defeated(enemy_id: String) -> bool:
	return defeated_enemies.get(enemy_id, false)


func mark_enemy_defeated(enemy_id: String) -> void:
	defeated_enemies[enemy_id] = true
