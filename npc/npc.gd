class_name NPC extends CharacterBody2D

signal dialogue_started
signal dialogue_ended

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dialogue_area: Area2D = $DialogueArea

@export var npc_name: String = "John"
@export var profile_texture: Texture2D

var is_in_dialogue: bool = false


func _ready() -> void:
	pass


func start_dialogue() -> void:
	is_in_dialogue = true
	dialogue_started.emit()


func end_dialogue() -> void:
	is_in_dialogue = false
	dialogue_ended.emit()


func get_profile() -> Texture2D:
	if profile_texture:
		return profile_texture
	return null
