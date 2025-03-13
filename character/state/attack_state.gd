class_name AttackState extends State

@export var attack_movement_speed: float = 0.6

var attack_direction: Vector2 = Vector2.ZERO
var current_velocity: Vector2 = Vector2.ZERO


func enter() -> void:
	var active_item = GameManager.character.inventory.get_active_item()

	if active_item is WeaponItem:
		var damage = 1

		GameManager.character.is_attacking = true
		GameManager.character.can_attack = false
		attack_direction = GameManager.character.last_direction
		damage = active_item.damage

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
