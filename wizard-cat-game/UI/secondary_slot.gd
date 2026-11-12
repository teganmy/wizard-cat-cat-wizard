extends PanelContainer

@export var texture_rect: TextureRect

func _ready() -> void:
	var eq = PlayerState.equipped_secondary
	if eq != -1:
		texture_rect.texture = PlayerState.secondaries[eq].icon

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is SecondaryAttack:
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	_equip_secondary(data)

func _equip_secondary(sec: SecondaryAttack) -> void:
	texture_rect.texture = sec.icon
	PlayerState.set_equipped_secondary_type.call_deferred(sec)
