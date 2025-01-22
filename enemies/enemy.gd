class_name Enemy extends CharacterBody2D

signal died

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: EnemyStateMachine = $StateMachine

@export_range(0, 100) var max_health: int = 3
@export_range(10, 200) var move_speed: float = 50.0

@export var hit_flash_duration: float = 0.2
@export var knockback_force: float = 100.0

var is_knocked_back: bool = false

var current_health: int:
	set(value):
		current_health = clampi(value, 0, max_health)
		if current_health <= 0:
			die()


func _ready() -> void:
	current_health = max_health


func _physics_process(delta: float) -> void:
	if state_machine.current_state:
		state_machine.physics_update(delta)
	move_and_slide()


func take_damage(amount: int) -> void:
	current_health -= amount
	flash_hit()
	apply_knockback()


func die() -> void:
	died.emit()
	queue_free()


func face_player() -> void:
	if GameManager.character:
		sprite.flip_h = GameManager.character.global_position.x > global_position.x


func play_animation(animation_name: String) -> void:
	if animation_player.has_animation(animation_name):
		animation_player.play(animation_name)


func flash_hit() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 0, 0), hit_flash_duration * 0.2)
	tween.tween_property(self, "modulate", Color(1.5, 1.5, 1.5), hit_flash_duration * 0.3)
	tween.tween_property(self, "modulate", Color(1, 1, 1), hit_flash_duration * 0.5)


func apply_knockback() -> void:
	if GameManager.character:
		is_knocked_back = true

		var knockback_direction = (
			(global_position - GameManager.character.global_position).normalized()
		)
		velocity = knockback_direction * knockback_force

		await get_tree().create_timer(0.25).timeout
		velocity = Vector2.ZERO
		is_knocked_back = false
