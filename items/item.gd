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
@export_range(0, 100) var heal_amount: int = 0
@export var use_animation_prefix: String = ""


func use(character: Character) -> bool:
	match item_type:
		ItemType.CONSUMABLE:
			if heal_amount > 0:
				return character.heal(heal_amount)
		ItemType.WEAPON:
			pass
	return false
