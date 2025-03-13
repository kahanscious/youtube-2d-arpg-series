class_name Inventory extends Node

signal inventory_changed

@export var hotbar_slots: int = 4
@export var backpack_rows: int = 3

var max_slots: int = 16
var items: Array[Dictionary] = []
var active_slot_index: int = -1


func _ready() -> void:
	var total_slots = hotbar_slots + (backpack_rows * hotbar_slots)
	max_slots = total_slots

	for i in range(max_slots):
		items.append({"item": null, "quantity": 0})


func get_active_item() -> Item:
	if active_slot_index >= 0 and active_slot_index < hotbar_slots:
		return items[active_slot_index].item
	return null


func set_active_slot(index: int) -> void:
	active_slot_index = index
	inventory_changed.emit()


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
			slot.item = item
			slot.quantity = min(quantity, item.max_stack_size)
			inventory_changed.emit()
			return true

	return false


func has_item(item_id: String) -> bool:
	for slot in items:
		if slot.item and slot.item.id == item_id:
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
