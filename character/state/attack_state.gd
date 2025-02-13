class_name AttackState extends State

@export var attack_movement_speed: float = 0.6

var attack_direction: Vector2 = Vector2.ZERO
var current_velocity: Vector2 = Vector2.ZERO


func enter() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var slots = GameManager.character.get_node("InventoryBar/Control/HBoxContainer/Slots")
	if slots:
		for slot in slots.get_children():
			if slot.get_global_rect().has_point(mouse_pos):
				state_machine.change_state("idle")
				return

	GameManager.character.is_attacking = true
	GameManager.character.can_attack = false
	attack_direction = GameManager.character.last_direction

	GameManager.character.play_animation("attack_" + GameManager.character.get_direction_name())

	GameManager.character.sword_audio.pitch_scale = randf_range(0.8, 1.2)
	GameManager.character.sword_audio.play()


func exit() -> void:
	GameManager.character.is_attacking = false
	GameManager.character.can_attack = true

	attack_direction = Vector2.ZERO
	current_velocity = Vector2.ZERO
	GameManager.character.velocity = Vector2.ZERO


func physics_update(_delta: float) -> void:
	if GameManager.character.direction != Vector2.ZERO:
		current_velocity = (
			GameManager.character.direction * (GameManager.character.speed * attack_movement_speed)
		)
	else:
		current_velocity = Vector2.ZERO

	GameManager.character.velocity = current_velocity

	if not GameManager.character.animation_player.is_playing():
		if GameManager.character.direction != Vector2.ZERO:
			state_machine.change_state("move")
		else:
			state_machine.change_state("idle")
