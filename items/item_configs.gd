extends Resource

const ITEM_CONFIGS = {
	"health_potion":
	{
		"scale": Vector2(0.5, 0.5),
	}
}


static func get_config(item_id: String) -> Dictionary:
	return ITEM_CONFIGS.get(item_id, {})
