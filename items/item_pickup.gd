@tool
class_name ItemPickup extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var item: Item:
	set(new_item):
		item = new_item
		if Engine.is_editor_hint() and is_node_ready():
			_update_sprite()
@export var quantity: int = 1

const ItemConfig = preload("res://items/item_configs.gd")


func _ready() -> void:
	if not item:
		printerr("ItemPickup: no item resource found!")
		return

	if not sprite:
		printerr("ItemPickup: no sprite node found!")
		return

	_update_sprite()

	if not Engine.is_editor_hint():
		await get_tree().process_frame

		var config = ItemConfig.get_config(item.id)
		if config.has("scale"):
			scale = config.scale


func _update_sprite() -> void:
	if item and item.get("icon") and sprite:
		sprite.texture = item.icon


func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		var inventory = body.get_node("Inventory")
		if inventory and inventory.add_item(item, quantity):
			queue_free()
