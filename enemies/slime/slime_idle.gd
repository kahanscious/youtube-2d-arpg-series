class_name SlimeIdleState extends EnemyState

@export var detect_range: float = 50.0

var enemy: Enemy


func enter():
	enemy = owner as Enemy
	enemy.velocity = Vector2.ZERO
	enemy.animation_player.play("idle")


func physics_update(_delta: float) -> void:
	var distance = enemy.global_position.distance_to(GameManager.character.global_position)
	if distance < detect_range:
		state_machine.change_state("move")
