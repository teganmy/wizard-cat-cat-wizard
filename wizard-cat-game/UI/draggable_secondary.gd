extends Control

@export var def: SecondaryAttack
var rect: TextureRect

func _ready() -> void:
	rect = TextureRect.new()
	rect.texture = def.icon
	add_child(rect)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not def:
		return null
	set_drag_preview(rect.duplicate())
	return def
