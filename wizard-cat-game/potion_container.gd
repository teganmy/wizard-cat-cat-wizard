extends HBoxContainer

const SLOT_SIZE := Vector2(20, 20)

func _ready() -> void:
	PlayerState.potions_changed.connect(_refresh)
	_refresh()

func _refresh() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	for i in PlayerState.max_potions:
		add_child(_make_slot(i))

func _make_slot(index: int) -> Control:
	var slot := ColorRect.new()
	slot.custom_minimum_size = SLOT_SIZE
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var is_selected := index == 0 and not PlayerState.potions.is_empty()
	slot.color = Color(1, 1, 1, 0.5) if is_selected else Color(0, 0, 0, 0.4)
	if index < PlayerState.potions.size():
		var potion: LootType = PlayerState.potions[index]
		var icon := TextureRect.new()
		icon.texture = potion.sprite
		icon.modulate = potion.tint
		icon.set_anchors_preset(Control.PRESET_FULL_RECT)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		slot.add_child(icon)
	return slot
