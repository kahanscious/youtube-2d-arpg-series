extends CanvasLayer

signal transition_started
signal transition_finished

@onready var color_rect: ColorRect = $ColorRect

var is_transitioning: bool = false
var next_spawn_point: String = ""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func transition_to_scene(path: String, next_spawn_point: String) -> void:
	if is_transitioning:
		return

	is_transitioning = true
	self.next_spawn_point = next_spawn_point

	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, 0.5)
	await tween.finished

	transition_started.emit()

	get_tree().change_scene_to_file(path)

	tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, 0.5)
	await tween.finished

	is_transitioning = false
	transition_finished.emit()
