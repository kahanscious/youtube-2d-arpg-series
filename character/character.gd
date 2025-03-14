class_name Character extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var sword_audio: AudioStreamPlayer = $SwordAudio
@onready var health_bar: ProgressBar = $HealthBar/ProgressBar
@onready var camera: PlayerCamera = $Camera2D
@onready var hitbox: Hitbox = $Hitbox
@onready var inventory_bar: InventoryBar = $Inventory/InventoryBar
@onready var inventory_backpack: CanvasLayer = $Inventory/InventoryBackpack
@onready var inventory: Inventory = $Inventory

@export var speed: float = 100.0
@export var acceleration: float = 800.0
@export var friction: float = 1000.0
@export var max_health: int = 10
@export var invulvnerability_time: float = 0.6
@export var character_name: String = "kahanscious"

var current_health: int = max_health
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN
var can_attack: bool = true
var is_attacking: bool = false
var is_invulnerable: bool = false


func _ready() -> void:
	GameManager.character = self
	animation_player.play("idle_down")

	health_bar.max_value = max_health
	health_bar.value = current_health


func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if not is_attacking and direction != Vector2.ZERO:
		last_direction = direction.normalized()

	state_machine.physics_update(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)


func play_animation(animation_name: String) -> void:
	if animation_player.has_animation(animation_name):
		if is_attacking and animation_player.current_animation.begins_with("attack"):
			return

		sprite.flip_h = animation_name.contains("left")
		if animation_name.contains("left"):
			animation_name = animation_name.replace("left", "right")
		animation_player.play(animation_name)


func get_direction_name() -> String:
	if last_direction.x < 0:
		sprite.flip_h = true
		hitbox.scale.x = -1
		return "left"
	if last_direction.x > 0:
		sprite.flip_h = false
		hitbox.scale.x = 1
		return "right"
	if last_direction.y < 0:
		return "up"
	return "down"


func take_damage(amount: int) -> void:
	if is_invulnerable:
		return

	current_health -= amount
	health_bar.value = current_health

	if current_health <= 0:
		print("Character died!")
	else:
		if animation_player.has_animation("hit"):
			animation_player.play("hit")
		start_invulnerability()


func start_invulnerability() -> void:
	is_invulnerable = true
	await get_tree().create_timer(invulvnerability_time).timeout
	is_invulnerable = false


func heal(amount: int) -> bool:
	if current_health >= max_health:
		return false

	current_health = min(current_health + amount, max_health)
	health_bar.value = current_health
	return true
