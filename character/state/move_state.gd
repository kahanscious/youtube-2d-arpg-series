class_name MoveState extends State


func physics_update(_delta: float) -> void:
	if GameManager.character.direction == Vector2.ZERO:
		state_machine.change_state("idle")
		return

	GameManager.character.last_direction = GameManager.character.direction.normalized()
	GameManager.character.velocity = (
		GameManager.character.last_direction * GameManager.character.speed
	)

	GameManager.character.play_animation("move_" + GameManager.character.get_direction_name())

	if Input.is_action_just_pressed("attack") and GameManager.character.can_attack:
		state_machine.change_state("attack")
