extends Control

@export var def: SecondaryAttack
@export var label: Label
@export var rect: TextureRect

func _ready() -> void:
	rect.texture = def.icon
	label.text = def.display_name

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not def:
		return null
	set_drag_preview(rect.duplicate())
	return def
