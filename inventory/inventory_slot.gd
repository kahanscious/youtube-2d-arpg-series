class_name InventorySlot extends TextureRect

@onready var slot_number: Label = $SlotNumber
@onready var item_icon: TextureRect = $ItemIcon
@onready var quantity_label: Label = $QuantityLabel
@onready var normal_texture = texture

@export var selected_texture: AtlasTexture

var slot_index: int = 0
var _pending_slot_index: int = -1


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
