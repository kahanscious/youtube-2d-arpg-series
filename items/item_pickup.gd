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
@export var pickup_delay: float = 0.7

var can_be_picked_up: bool = false


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
		scale = item.pickup_scale

		if collision_shape:
			collision_shape.disabled = true

		await get_tree().create_timer(pickup_delay).timeout
		if collision_shape:
			collision_shape.disabled = false
			can_be_picked_up = true


func _update_sprite() -> void:
	if item and item.get("icon") and sprite:
		sprite.texture = item.icon

		if collision_shape and not collision_shape.shape:
			var circle = CircleShape2D.new()
			circle.radius = 10.0
			collision_shape.shape = circle


func _on_body_entered(body: Node2D) -> void:
	if not can_be_picked_up:
		return

	if body is Character:
		var inventory = body.get_node("Inventory")
		if inventory and inventory.add_item(item, quantity):
			queue_free()
