extends Level

@onready var slime: Enemy = $Slime
@onready var cave_entry_blocker: StaticBody2D = $CaveEntryBlocker


func _ready() -> void:
	super._ready()

	slime.died.connect(_on_slime_death)


func _on_slime_death() -> void:
	cave_entry_blocker.queue_free()
