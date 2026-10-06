extends HBoxContainer

@export var life_sprite: Texture2D

func add_life() -> void:
	var life = TextureRect.new()
	life.set_texture(life_sprite)
	add_child(life)
