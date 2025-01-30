# Global game manager that handles character instantiation and game state
# Maintains references to key game objects and manages starting conditions
extends Node

var character_scene: PackedScene = preload("res://character/character.tscn")
var character: Character = null


func _ready() -> void:
	character = character_scene.instantiate()
	SceneTransition.next_spawn_point = "Default"
