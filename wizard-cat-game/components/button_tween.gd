class_name ButtonTween
extends Node

@export var buttons: Array[Button] = []
@export var active: bool =  true
@export_group("Behavior")
@export var anim_time: float = 0.2
@export var hover_scale: Vector2 = Vector2(1.05, 1.05)
@export var press_scale: Vector2 = Vector2(0.9,0.9)
@export var transition := Tween.TRANS_BACK


func activate() -> void:
	active = true

func deactivate() -> void:
	active = false

func _ready() -> void:
	for button in buttons:
		_connect_button(button)

func _connect_button(button: Button) -> void:
	button.mouse_entered.connect(_activate_button.bind(button.get_path()))
	button.mouse_exited.connect(_deactivate_button.bind(button.get_path()))
	button.button_down.connect(_pressed_button.bind(button.get_path()))
	button.button_up.connect(_unpressed_button.bind(button.get_path()))

func _disconnect_button(button: Button) -> void:
	if button in buttons:
		button.mouse_entered.disconnect(_activate_button)
		button.mouse_exited.disconnect(_deactivate_button)
		button.button_down.disconnect(_pressed_button)
		button.button_up.disconnect(_unpressed_button)

func remove_button(button: Button) -> void:
	var index = buttons.find(button)
	if index != -1:
		_disconnect_button(button)
		buttons.remove_at(index)

func add_button(button: Button) -> void:
	if button not in buttons:
		buttons.append(button)
		_connect_button(button)

func _activate_button(button: NodePath) -> void:
	if active:
		var button_node = get_node(button)
		if button_node:
			button_node.pivot_offset_ratio = Vector2(0.5,0.5)
			create_tween().set_trans(transition).tween_property(button_node, "scale", hover_scale, anim_time)

func _deactivate_button(button: NodePath) -> void:
	if active:
		var button_node = get_node(button)
		if button_node:
			button_node.pivot_offset_ratio = Vector2(0.5,0.5)
			create_tween().set_trans(transition).tween_property(button_node, "scale", Vector2.ONE, anim_time)

func _pressed_button(button: NodePath) -> void:
	if active:
		var button_node = get_node(button)
		if button_node:
			button_node.pivot_offset_ratio = Vector2(0.5,0.5)
			create_tween().set_trans(transition).tween_property(button_node, "scale", press_scale, anim_time)

func _unpressed_button(button: NodePath) -> void:
	if active:
		var button_node = get_node(button)
		if button_node:
			button_node.pivot_offset_ratio = Vector2(0.5,0.5)
			create_tween().set_trans(transition).tween_property(button_node, "scale", hover_scale, anim_time)
