# Global state manager that persists game progress and world state
# Tracks defeated enemies, opened chests, and collected items
extends Node

# Store state of enemies, chests, etc.
var defeated_enemies: Dictionary = {} # key: unique_id, value: true if defeated
var opened_chests: Dictionary = {} # key: unique_id, value: true if opened
var collected_items: Dictionary = {} # key: item_id, value: quantity
var broken_rocks: Dictionary = {} # key: rock_id, value: true if broken

# Checks if a specific enemy has been defeated
func is_enemy_defeated(enemy_id: String) -> bool:
	return defeated_enemies.get(enemy_id, false)

# Marks an enemy as defeated in the game state
func mark_enemy_defeated(enemy_id: String) -> void:
	defeated_enemies[enemy_id] = true
	
# Checks if a specific chest has been opened
func is_chest_opened(chest_id: String) -> bool:
	return opened_chests.get(chest_id, false)
	
# Marks a chest as opened in the game state
func mark_chest_opened(chest_id: String) -> void:
	opened_chests[chest_id] = true

# Checks if a specific rock has been broken
func is_rock_broken(rock_id: String) -> bool:
	return broken_rocks.get(rock_id, false)

# Marks a rock as broken in the game state
func mark_rock_broken(rock_id: String) -> void:
	broken_rocks[rock_id] = true
