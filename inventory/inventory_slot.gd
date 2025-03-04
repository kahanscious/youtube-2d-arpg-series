class_name InventorySlot extends TextureRect

@onready var slot_number: Label = $SlotNumber
@onready var item_icon: TextureRect = $ItemIcon
@onready var quantity_label: Label = $QuantityLabel
@onready var normal_texture = texture

@export var selected_texture: AtlasTexture

var slot_index: int = 0
var _pending_slot_index: int = -1
var dragging: bool = false
var drag_data: Dictionary = {}
var is_hotbar_slot: bool = false:
	set(value):
		is_hotbar_slot = value
		if value:
			modulate = Color.WHITE
		else:
			modulate = Color(1.2, 1.2, 0.9)

static var held_item: Dictionary = {}
static var original_slot_index: int = -1
static var is_dragging_item: bool = false

const SNAP_DISTANCE: float = 32.0


func _ready() -> void:
	if _pending_slot_index != -1:
		slot_number.text = str(_pending_slot_index + 1)
		slot_index = _pending_slot_index
	else:
		slot_number.text = str(slot_index + 1)

	quantity_label.text = ""
	quantity_label.visible = false


func set_item(item: Item, quantity: int) -> void:
	item_icon.texture = item.icon
	item_icon.visible = true
	quantity_label.text = str(quantity) if quantity > 1 else ""
	quantity_label.visible = quantity > 1


func clear() -> void:
	item_icon.texture = null
	item_icon.visible = false
	quantity_label.visible = false


func set_slot_index(index: int) -> void:
	if not is_node_ready():
		_pending_slot_index = index
		return

	slot_index = index
	slot_number.text = str(index + 1)


func set_selected(selected: bool) -> void:
	texture = selected_texture if selected else normal_texture


func get_inventory() -> Inventory:
	var inventory_bar = owner
	if inventory_bar:
		var inventory = inventory_bar.inventory
		if inventory:
			return inventory

	var parent = get_parent()
	while parent:
		if parent.has_node("Inventory"):
			return parent.get_node("Inventory")
		parent = parent.get_parent()

	return null


func _get_drag_data(_position: Vector2) -> Variant:
	var inventory = get_inventory()
	if not inventory or not item_icon.visible:
		return null

	var preview = TextureRect.new()
	preview.texture = item_icon.texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.custom_minimum_size = Vector2(16, 16)
	preview.modulate = Color(1, 1, 1, 0.7)

	var control = Control.new()
	control.add_child(preview)
	preview.position = -0.5 * preview.custom_minimum_size

	held_item = {
		"item": inventory.items[slot_index].item, "quantity": inventory.items[slot_index].quantity
	}

	original_slot_index = slot_index
	is_dragging_item = true
	dragging = true
	inventory.items[slot_index].item = null
	inventory.items[slot_index].quantity = 0
	inventory.inventory_changed.emit()

	set_drag_preview(control)

	return held_item


func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	var inventory = get_inventory()
	if not inventory:
		return false
	return data is Dictionary and data.has("item") and inventory.items[slot_index].item == null


func _drop_data(_position: Vector2, data: Variant) -> void:
	var inventory = get_inventory()
	if not inventory:
		return

	var current_slot_data = inventory.items[slot_index]

	if current_slot_data.item == null:
		current_slot_data.item = held_item.item
		current_slot_data.quantity = held_item.quantity
		held_item.clear()
		original_slot_index = -1
		is_dragging_item = false
		dragging = false
		inventory.inventory_changed.emit()


func return_held_item_to_inventory() -> void:
	var inventory = get_inventory()
	if held_item.is_empty() or not inventory:
		return

	if original_slot_index != -1:
		inventory.items[original_slot_index].item = held_item.item
		inventory.items[original_slot_index].quantity = held_item.quantity
	else:
		print("Original slot not found - this shouldn't happen!")

	held_item.clear()
	original_slot_index = -1
	is_dragging_item = false
	inventory.inventory_changed.emit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not held_item.is_empty():
			return_held_item_to_inventory()
			is_dragging_item = false
			dragging = false
			get_viewport().set_input_as_handled()


func find_closest_slot(global_pos: Vector2) -> InventorySlot:
	var closest_slot: InventorySlot = null
	var inventory_bar = owner

	if not inventory_bar or not inventory_bar.slots:
		return null

	for slot in inventory_bar.slots.get_children():
		if not slot is InventorySlot:
			continue
		var slot_center = slot.global_position + slot.size * 0.5
		var distance = global_pos.distance_to(slot_center)

		if distance < SNAP_DISTANCE:
			closest_slot = slot

	return closest_slot


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		if dragging and not held_item.is_empty():
			var mouse_pos = get_viewport().get_mouse_position()
			var closest_slot = find_closest_slot(mouse_pos)

			if closest_slot:
				closest_slot._drop_data(Vector2.ZERO, held_item)
			else:
				return_held_item_to_inventory()

			is_dragging_item = false
			dragging = false
