extends PanelContainer

@export var texture_rect: TextureRect
@export var label: Label

func _ready() -> void:
	var eq = PlayerState.equipped_secondary
	if eq != -1:
		_equip_secondary(PlayerState.secondaries[eq])

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is SecondaryAttack:
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	_equip_secondary(data)

func _equip_secondary(sec: SecondaryAttack) -> void:
	texture_rect.texture = sec.icon
	label.text = sec.display_name
	PlayerState.set_equipped_secondary_type.call_deferred(sec)
