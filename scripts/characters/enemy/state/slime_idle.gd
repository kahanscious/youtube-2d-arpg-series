class_name SlimeIdleState extends EnemyState

@export var detect_range: float = 100.0


func physics_update(delta: float) -> void:
	var enemy = owner as Enemy
	var distance = enemy.global_position.distance_to(GameManager.character.global_position)
	if distance < detect_range:
		state_machine.change_state("move")
