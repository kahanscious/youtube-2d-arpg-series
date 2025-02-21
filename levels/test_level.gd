extends Level

@onready var slime: Enemy = $Slime
@onready var cave_entry_blocker: StaticBody2D = $CaveEntryBlocker
@onready var bridge_guard: NPC = $BridgeGuard


func _ready() -> void:
	super._ready()

	if is_instance_valid(slime):
		slime.died.connect(_on_slime_death)

	if GameState.is_enemy_defeated(slime.enemy_id):
		cave_entry_blocker.queue_free()

	bridge_guard.dialogue_area.dialogue_triggered.connect(
		func(dialogue_set: DialogueSet, npc: NPC):
			var player_name = GameManager.character.character_name
			var current_set = dialogue_set.dialogues
			current_set[0].player_name = player_name
			DialogueManager.start_dialogue(current_set, npc)
	)
	DialogueManager.dialogue_finished.connect(bridge_guard._on_dialogue_finished)


func _on_slime_death() -> void:
	cave_entry_blocker.queue_free()
