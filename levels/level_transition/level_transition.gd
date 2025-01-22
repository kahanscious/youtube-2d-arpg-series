extends Area2D

@export_file("*.tscn") var next_level_path: String


func _on_body_entered(body: Node2D) -> void:
	if body is Character and next_level_path and not SceneTransition.is_transitioning:
		SceneTransition.transition_to_scene(next_level_path)
