class_name Inventory extends Node

signal inventory_changed

@export var max_slots: int = 10

var items: Array[Dictionary] = []


func _ready() -> void:
	for i in range(max_slots):
		items.append({"item": null, "quantity": 0})


func add_item(item: Item, quantity: int = 1) -> bool:
	if item.stackable:
		for slot in items:
			if slot.item and slot.item.id == item.id and slot.quantity < item.max_stack_size:
				var space_left = item.max_stack_size - slot.quantity
				var amount_to_add = min(quantity, space_left)
				slot.quantity += amount_to_add
				quantity -= amount_to_add
				if quantity == 0:
					inventory_changed.emit()
					return true

	for slot in items:
		if not slot.item:
			slot.item = items
			slot.quantity = min(quantity, item.max_stack_size)
			inventory_changed.emit()
			return true

	return false


func has_item(item_id: String) -> bool:
	for slot in items:
		if slot.item and slot.item_id == item_id:
			return true
	return false


func remove_item(item_id: String, quantity: int = 1) -> bool:
	for slot in items:
		if slot.item and slot.item.id == item_id:
			if slot.quantity >= quantity:
				slot.quantity -= quantity
				if slot.quantity == 0:
					slot.item = null
				inventory_changed.emit()
				return true
	return false


func get_item(item_id: String) -> Item:
	for slot in items:
		if slot.item and slot.item.id == item_id:
			return slot.item

	return null
