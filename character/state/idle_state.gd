class_name IdleState extends State


func enter() -> void:
	GameManager.character.velocity = Vector2.ZERO
	GameManager.character.play_animation("idle_" + GameManager.character.get_direction_name())


func physics_update(_delta: float) -> void:
	if GameManager.character.direction != Vector2.ZERO:
		state_machine.change_state("move")

	if Input.is_action_just_pressed("attack") and GameManager.character.can_attack:
		state_machine.change_state("attack")
