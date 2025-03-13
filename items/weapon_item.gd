class_name WeaponItem extends Item

@export var damage: int = 1


func use(character: Character) -> bool:
	character.state_machine.change_state("attack")
	return true
