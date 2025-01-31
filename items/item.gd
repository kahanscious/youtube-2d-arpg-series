class_name Item extends Resource

enum ItemType { CONSUMABLE, WEAPON }

@export var id: String
@export var name: String
@export var icon: Texture2D
@export var description: String
@export var stackable: bool = false
@export var max_stack_size: int = 1
@export var item_type: ItemType
@export var damage: int = 0
@export var use_animation_prefix: String = ""
