extends Level

@onready var slime: Enemy = $Slime
@onready var cave_entry_blocker: StaticBody2D = $CaveEntryBlocker


func _ready() -> void:
	super._ready()

	if is_instance_valid(slime):
		slime.died.connect(_on_slime_death)

	if GameState.is_enemy_defeated(slime.enemy_id):
		cave_entry_blocker.queue_free()


func _on_slime_death() -> void:
	cave_entry_blocker.queue_free()


func _on_item_pickup_body_entered(body: Node2D) -> void:
	pass
