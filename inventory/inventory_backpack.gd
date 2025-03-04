extends CanvasLayer

@onready var backpack_container: Control = $BackpackContainer
@onready
var slots_container: GridContainer = $BackpackContainer/MarginContainer/VBoxContainer/SlotsContainer
@onready var close_button: TextureButton = $CloseButton

const SLOT_SCENE = preload("res://inventory/inventory_slot.tscn")

var inventory: Inventory
var is_open: bool = false
var inventory_bar: InventoryBar


func _ready() -> void:
	backpack_container.hide()
	close_button.hide()

	inventory = get_parent()
	inventory_bar = get_node("../InventoryBar")

	close_button.pressed.connect(toggle_backpack)

	if inventory:
		inventory.inventory_changed.connect(_on_inventory_changed)
		slots_container.columns = inventory.hotbar_slots
		_create_slots(inventory.max_slots)
	else:
		printerr("No inventory found!")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_backpack"):
		toggle_backpack()


func toggle_backpack() -> void:
	is_open = !is_open
	backpack_container.visible = is_open
	close_button.visible = is_open

	if inventory_bar:
		inventory_bar.get_node("Control").visible = !is_open

	get_tree().paused = is_open

	if is_open:
		_on_inventory_changed()


func _create_slots(count: int) -> void:
	for i in range(count):
		var slot = SLOT_SCENE.instantiate()
		slot.set_slot_index(i)

		if i < inventory.hotbar_slots:
			slot.is_hotbar_slot = true
		else:
			slot.is_hotbar_slot = false

		slots_container.add_child(slot)

	_on_inventory_changed()


func _on_inventory_changed() -> void:
	for i in range(inventory.items.size()):
		if i < slots_container.get_child_count():
			var slot = slots_container.get_child(i)
			var item_data = inventory.items[i]

			if i < inventory.hotbar_slots:
				slot.is_hotbar_slot = true
			else:
				slot.is_hotbar_slot = false

			if item_data.item:
				slot.set_item(item_data.item, item_data.quantity)
			else:
				slot.clear()
