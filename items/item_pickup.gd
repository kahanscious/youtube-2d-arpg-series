class_name ItemPickup extends Area2D

const ItemConfig = preload("res://items/item_config.gd")

@export var item: Item
@export var quantity: int = 1

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if not item:
		printerr("ItemPickup: No item resource assigned!")
		return

	if not sprite:
		printerr("ItemPickup: No Sprite2D node found!")
		return

	sprite.texture = item.icon

	var config = ItemConfig.get_config(item.id)
	if config.has("scale"):
		sprite.scale = config.scale
		collision_shape.scale = config.scale


func _on_body_entered(body: Node2D) -> void:
	if body is Character:
		var inventory = body.get_node("Inventory")
		if inventory and inventory.add_item(item, quantity):
			queue_free()
