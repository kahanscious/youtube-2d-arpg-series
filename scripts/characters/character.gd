class_name Character extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed: float = 100.0
@export var acceleration: float = 800.0
@export var friction: float = 1000.0

var last_direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	animation_player.play("idle_down")


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction.length() > 0:
		direction = direction.normalized()
		
	if direction != Vector2.ZERO:
		last_direction = direction
	
	velocity = direction * speed
	
	handle_animations()
	
	move_and_slide()
	
func handle_animations() -> void:
	if velocity != Vector2.ZERO:
		if velocity.x < 0:
			animation_player.play("move_left")
		elif velocity.x > 0:
			animation_player.play("move_right")
		elif velocity.y < 0:
			animation_player.play("move_up")
		else:
			animation_player.play("move_down")
	else:
		if last_direction.x < 0:
			animation_player.play("idle_left")
		elif last_direction.x > 0:
			animation_player.play("idle_right")
		elif last_direction.y < 0:
			animation_player.play("idle_up")
		else:
			animation_player.play("idle_down")
			
			
			
			
			
			
			
