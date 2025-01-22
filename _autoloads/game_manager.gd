extends Node

var character_scene: PackedScene = preload("res://character/character.tscn")
var character: Character = null


func _ready() -> void:
	character = character_scene.instantiate()
