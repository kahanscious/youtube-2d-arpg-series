class_name Hitbox extends Area2D

@export var damage: int = 1

var has_hit: bool = false


func _ready() -> void:
	area_entered.connect(_on_hitbox_area_entered)


func reset_hit_status() -> void:
	has_hit = false


func _on_hitbox_area_entered(area: Area2D) -> void:
	if has_hit:
		return

	if area is Hurtbox and area.owner.has_method("take_damage"):
		has_hit = true
		area.owner.take_damage(damage)
		reset_hit_status()
