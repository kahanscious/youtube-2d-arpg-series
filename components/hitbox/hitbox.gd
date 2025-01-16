class_name Hitbox extends Area2D
# deal damage

@export var damage: int = 1


func _ready() -> void:
	area_entered.connect(_on_hitbox_area_entered)


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Hurtbox and area.owner.has_method("take_damage"):
		area.owner.take_damage(damage)
