class_name InventoryBar extends CanvasLayer

@onready var slots: HBoxContainer = $Control/HBoxContainer/Slots
@onready var control: Control = $Control

const SLOT_SCENE = preload("res://inventory/inventory_slot.tscn")

var inventory: Inventory
var selected_slot: int = -1


func _ready() -> void:
	inventory = get_parent()
	if inventory:
		inventory.inventory_changed.connect(_on_inventory_changed)
		_create_slots(inventory.hotbar_slots)
	else:
		print("No inventory found!")


func _process(delta: float) -> void:
	if DialogueManager.is_dialogue_active:
		control.hide()
	else:
		control.show()


func _create_slots(count: int) -> void:
	for i in range(count):
		var slot = SLOT_SCENE.instantiate()
		slot.set_slot_index(i)
		slots.add_child(slot)


func _input(event: InputEvent) -> void:
	if event.is_pressed():
		for i in range(4):
			if Input.is_key_pressed(KEY_1 + i):
				select_slot(i)
				get_viewport().set_input_as_handled()

	if event.is_action_pressed("use_item") and selected_slot != -1:
		use_selected_item()


func select_slot(index: int) -> void:
	if index >= 0 and index < inventory.items.size():
		var item_data = inventory.items[index]

		if not item_data.item and index != selected_slot:
			return

	if index == selected_slot:
		selected_slot = -1
		inventory.set_active_slot(-1)
	else:
		selected_slot = index
		inventory.set_active_slot(index)

	for i in range(slots.get_child_count()):
		var slot = slots.get_child(i)
		slot.set_selected(i == selected_slot)


func use_selected_item() -> void:
	if selected_slot >= 0 and selected_slot < inventory.items.size():
		var item_data = inventory.items[selected_slot]
		if item_data.item:
			var character = owner as Character
			if character and item_data.item.use(character):
				if item_data.quantity > 1:
					item_data.quantity -= 1
				else:
					item_data.item = null
					item_data.quantity = 0
				inventory.inventory_changed.emit()
				select_slot(selected_slot)
			else:
				print("Failed to use item")


func _on_inventory_changed() -> void:
	for i in range(slots.get_child_count()):
		var slot = slots.get_child(i)
		var item_data = inventory.items[i]
		if item_data.item:
			slot.set_item(item_data.item, item_data.quantity)
		else:
			slot.clear()

		slot.set_selected(i == selected_slot)
