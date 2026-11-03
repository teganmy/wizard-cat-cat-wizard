extends Label

func _ready() -> void:
	PlayerState.potions_changed.connect(_refresh)
	_refresh()

func _refresh() -> void:
	var sel: LootType = PlayerState.selected()
	text = "Potions %d/%d" % [PlayerState.potions.size(), PlayerState.max_potions]
	if sel:
		text += "  [Q] " + sel.name
