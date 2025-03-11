@tool
class_name Chest extends StaticBody2D

enum ChestType { FOREST, CAVE, DESERT, TUNDRA }

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $InteractArea

@export var chest_type: ChestType = ChestType.FOREST:
	set(value):
		chest_type = value
		_update_chest_texture()
@export var forest_chest: Texture2D:
	set(value):
		forest_chest = value
		if chest_type == ChestType.FOREST:
			_update_chest_texture()
@export var cave_chest: Texture2D:
	set(value):
		cave_chest = value
		if chest_type == ChestType.CAVE:
			_update_chest_texture()
@export var desert_chest: Texture2D:
	set(value):
		desert_chest = value
		if chest_type == ChestType.DESERT:
			_update_chest_texture()
@export var tundra_chest: Texture2D:
	set(value):
		tundra_chest = value
		if chest_type == ChestType.TUNDRA:
			_update_chest_texture()

@export var loot: Array[Item] = []
@export var loot_quanitities: Array[int] = []

var can_interact: bool = false
var is_opened: bool = false


func _ready() -> void:
	pass


func _update_chest_texture():
	if not sprite:
		return

	match chest_type:
		ChestType.FOREST:
			sprite.texture = forest_chest
		ChestType.CAVE:
			sprite.texture = cave_chest
		ChestType.DESERT:
			sprite.texture = desert_chest
		ChestType.TUNDRA:
			sprite.texture = tundra_chest


func _input(event: InputEvent) -> void:
	if can_interact and event.is_action_pressed("interact") and not is_opened:
		animation_player.play("open")
		is_opened = true
		can_interact = false

		spawn_items()


func spawn_items() -> void:
	var item_pickup_scene = preload("res://items/item_pickup.tscn")

	for i in range(min(loot.size(), loot_quanitities.size())):
		if loot[i] != null:
			var pickup = item_pickup_scene.instantiate()
			pickup.item = loot[i]
			pickup.quantity = loot_quanitities[i]

			get_tree().current_scene.add_child(pickup)
			pickup.global_position = global_position - Vector2(0, 10)

			var tween = create_tween()
			var bounce_height = randf_range(10, 20)
			var bounce_distance = randf_range(5, 15) * sign(randf_range(-1, 1))
			var bounce_duration = randf_range(.3, .5)

			(
				tween
				. tween_property(
					pickup,
					"position",
					pickup.position + Vector2(bounce_distance / 2, -bounce_height),
					bounce_duration / 2
				)
				. set_ease(Tween.EASE_OUT)
			)

			(
				tween
				. tween_property(
					pickup,
					"position",
					pickup.position + Vector2(bounce_distance, 0),
					bounce_duration / 2
				)
				. set_ease(Tween.EASE_IN)
			)


func _on_interact_area_body_entered(body: Node2D) -> void:
	if body is Character and not is_opened:
		can_interact = true


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body is Character:
		can_interact = false
