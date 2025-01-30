extends Resource

const ITEM_CONFIGS = {
	"health_potion":
	{
		"scale": Vector2(0.5, 0.5),
		"heal_amount": 5,
		# Other potion-specific settings
	},
	"other_item":
	{
		"scale": Vector2(1, 1),
		# Other item settings
	}
}


static func get_config(item_id: String) -> Dictionary:
	return ITEM_CONFIGS.get(item_id, {})
