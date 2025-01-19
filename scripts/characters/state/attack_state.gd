class_name AttackState extends State


func enter() -> void:
	GameManager.character.is_attacking = true
	GameManager.character.can_attack = false
	GameManager.character.play_animation("attack_" + GameManager.character.get_direction_name())

	GameManager.character.sword_audio.pitch_scale = randf_range(0.8, 1.2)
	GameManager.character.sword_audio.play()


func exit() -> void:
	GameManager.character.is_attacking = false
	GameManager.character.can_attack = true


func physics_update(_delta: float) -> void:
	if not GameManager.character.animation_player.is_playing():
		state_machine.change_state("idle")
