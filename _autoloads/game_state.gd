extends Node

var defeated_enemies: Dictionary = {} # key: unique_id, value: true if defeated


# Checks if a specific enemy has been defeated
func is_enemy_defeated(enemy_id: String) -> bool:
	return defeated_enemies.get(enemy_id, false)

# Marks an enemy as defeated in the game state
func mark_enemy_defeated(enemy_id: String) -> void:
	defeated_enemies[enemy_id] = true
