class_name Slime extends Enemy

enum SlimeColor {
	DEFAULT,
	AQUAMARINE,
	BLUEGREEN,
	BLUE,
	DARKBLUE,
	GOLD,
	GREEN,
	LIGHTBLUE,
	MAROON,
	ORANGE,
	PALEGREEN,
	PINK,
	PURPLE,
	RED,
	VIOLET
}

const SLIME_TEXTURES = {
	SlimeColor.DEFAULT: preload("res://assets/characters/slimes/slime_purple_side.png"),
	SlimeColor.AQUAMARINE: preload("res://assets/characters/slimes/slime_aquamarine_side.png"),
	SlimeColor.BLUEGREEN: preload("res://assets/characters/slimes/slime_bluegreen_side.png"),
	SlimeColor.BLUE: preload("res://assets/characters/slimes/slime_blue_side.png"),
	SlimeColor.DARKBLUE: preload("res://assets/characters/slimes/slime_darkblue_side.png"),
	SlimeColor.GOLD: preload("res://assets/characters/slimes/slime_gold_side.png"),
	SlimeColor.GREEN: preload("res://assets/characters/slimes/slime_green_side.png"),
	SlimeColor.LIGHTBLUE: preload("res://assets/characters/slimes/slime_lightblue_side.png"),
	SlimeColor.MAROON: preload("res://assets/characters/slimes/slime_maroon_side.png"),
	SlimeColor.ORANGE: preload("res://assets/characters/slimes/slime_orange_side.png"),
	SlimeColor.PALEGREEN: preload("res://assets/characters/slimes/slime_palegreen_side.png"),
	SlimeColor.PINK: preload("res://assets/characters/slimes/slime_pink_side.png"),
	SlimeColor.PURPLE: preload("res://assets/characters/slimes/slime_purple_side.png"),
	SlimeColor.RED: preload("res://assets/characters/slimes/slime_red_side.png"),
	SlimeColor.VIOLET: preload("res://assets/characters/slimes/slime_violet_side.png")
}

@export var slime_color: SlimeColor = SlimeColor.DEFAULT:
	set(value):
		slime_color = value
		if sprite:
			_update_sprite_texture()

func _ready() -> void:
	super()
	_update_sprite_texture()

func _update_sprite_texture() -> void:
	sprite.texture = SLIME_TEXTURES.get(slime_color, SLIME_TEXTURES[SlimeColor.DEFAULT])
