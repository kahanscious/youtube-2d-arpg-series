class_name ConsumableItem extends Item

@export_range(0, 100) var heal_amount: int = 0
@export var effect_duration: float = 0.0


func use(character: Character) -> bool:
	if heal_amount > 0:
		return character.heal(heal_amount)
	return false
