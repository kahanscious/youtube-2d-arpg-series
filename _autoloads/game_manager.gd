extends Node

var character: Character = null


func register_character(c: Character) -> void:
	character = c
	
func get_character() -> Character:
	return character
