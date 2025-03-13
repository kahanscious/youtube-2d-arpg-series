class_name Item extends Resource

@export var id: String
@export var name: String
@export var icon: Texture2D
@export var description: String
@export var stackable: bool = false
@export var max_stack_size: int = 1
@export var use_animation_prefix: String = ""
@export var pickup_scale: Vector2 = Vector2.ONE


func use(character: Character) -> bool:
	return false
