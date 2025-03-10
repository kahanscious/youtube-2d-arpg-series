class_name SlimeMoveState extends EnemyState

@export var lose_interest_range: float = 75.0


func physics_update(_delta: float) -> void:
	var enemy = owner as Enemy
	if enemy.is_knocked_back:
		return

	var distance = enemy.global_position.distance_to(GameManager.character.global_position)
	if distance > lose_interest_range:
		state_machine.change_state("idle")
		return

	var dir = (GameManager.character.global_position - enemy.global_position).normalized()
	enemy.velocity = dir * enemy.move_speed
	enemy.face_player()
