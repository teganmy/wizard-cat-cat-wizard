class_name Shop
extends Control

@export var items: Array[ShopItem]
@export var grid: GridContainer
@export var coins_label: Label
@export var name_label: Label
@export var description_label: Label
@export var buy_button: Button
@export var close_button: Button

var _selected: ShopItem

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	PlayerState.currency_changed.connect(_on_currency_changed)
	PlayerState.upgrades_changed.connect(_refresh)
	PlayerState.potions_changed.connect(_refresh)
	PlayerState.secondary_changed.connect(_on_secondary_changed)
	buy_button.pressed.connect(_on_buy_pressed)
	close_button.pressed.connect(close)
	for item in items:
		var button := Button.new()
		button.custom_minimum_size = Vector2(56, 56)
		button.tooltip_text = item.name
		button.pressed.connect(_select.bind(item))
		button.focus_entered.connect(_select.bind(item))
		var icon := TextureRect.new()
		icon.texture = item.icon
		icon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 10)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(icon)
		grid.add_child(button)

func open() -> void:
	show()
	get_tree().paused = true
	if _selected == null and not items.is_empty():
		_selected = items[0]
	_refresh()
	if grid.get_child_count() > 0:
		grid.get_child(0).grab_focus()

func close() -> void:
	hide()
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()

func _select(item: ShopItem) -> void:
	_selected = item
	_refresh()

func _on_currency_changed(_new: int) -> void:
	_refresh.call_deferred() # CHANGED: see below

func _on_secondary_changed(_type: LootType) -> void:
	_refresh()

func _blocked_reason(item: ShopItem) -> String:
	match item.kind:
		ShopItem.Kind.POTION:
			if PlayerState.potions.size() >= PlayerState.max_potions:
				return "Potion slots full"
		ShopItem.Kind.UPGRADE:
			if PlayerState.upgrade_level(item.upgrade_id) >= item.max_level:
				return "Sold out"
		ShopItem.Kind.SECONDARY:
			if PlayerState.secondary == item.loot:
				return "Equipped"
	if PlayerState.currency < item.current_price():
		return "Not enough coins"
	return ""

func _refresh() -> void:
	coins_label.text = str(PlayerState.currency)
	if _selected == null:
		buy_button.disabled = true
		return
	var title := _selected.name
	if _selected.kind == ShopItem.Kind.UPGRADE and _selected.max_level > 1:
		title += " (%d/%d)" % [PlayerState.upgrade_level(_selected.upgrade_id), _selected.max_level]
	name_label.text = title
	description_label.text = _selected.description
	var reason := _blocked_reason(_selected)
	buy_button.disabled = reason != ""
	buy_button.text = reason if reason != "" else "Buy (%d)" % _selected.current_price()

func _on_buy_pressed() -> void:
	if _selected == null or _blocked_reason(_selected) != "":
		return
	PlayerState.currency -= _selected.current_price() # before the level changes
	match _selected.kind:
		ShopItem.Kind.POTION:
			PlayerState.add_potion(_selected.loot)
		ShopItem.Kind.SECONDARY:
			PlayerState.set_secondary(_selected.loot)
		ShopItem.Kind.UPGRADE:
			PlayerState.add_upgrade(_selected.upgrade_id)
