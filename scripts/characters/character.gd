class_name Character extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine

@export var speed: float = 100.0
@export var acceleration: float = 800.0
@export var friction: float = 1000.0
@export var max_health: int = 1

var current_health: int = max_health
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN
var can_attack: bool = true
var is_attacking: bool = false


func _ready() -> void:
	GameManager.register_character(self)
	animation_player.play("idle_down")


func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	state_machine.physics_update(delta)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)


func play_animation(animation_name: String) -> void:
	if animation_player.has_animation(animation_name):
		animation_player.play(animation_name)


func get_direction_name() -> String:
	if last_direction.x < 0:
		return "left"
	elif last_direction.x > 0:
		return "right"
	elif last_direction.y < 0:
		return "up"
	else:
		return "down"


func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		print("Character died!")
	else:
		if animation_player.has_animation("hit"):
			animation_player.play("hit")
