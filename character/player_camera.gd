class_name PlayerCamera extends Camera2D


func _ready() -> void:
	await get_tree().process_frame
	setup_camera_limits()


func setup_camera_limits() -> void:
	var tilemap: TileMapLayer = null
	var tilemaps := owner.get_tree().current_scene.get_node("Tilemaps").get_children()
	for map in tilemaps:
		if map.is_in_group("main_tilemap"):
			tilemap = map

	if not tilemap:
		push_warning("No main tilemap found for our camera bounds!")
		return

	var used_rect: Rect2i = tilemap.get_used_rect()
	var tilemap_size := tilemap.tile_set.get_tile_size()

	limit_left = used_rect.position.x * tilemap_size.x
	limit_top = used_rect.position.y * tilemap_size.y
	limit_right = (used_rect.position.x + used_rect.size.x) * tilemap_size.x
	limit_bottom = (used_rect.position.y + used_rect.size.y) * tilemap_size.y
