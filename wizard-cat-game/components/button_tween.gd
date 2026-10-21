class_name ButtonTween
extends Node

@export var buttons: Array[Button] = []
@export_group("Behavior")
@export var anim_time: float = 0.2
@export var hover_scale: Vector2 = Vector2(1.05, 1.05)
@export var press_scale: Vector2 = Vector2(0.9,0.9)
@export var transition := Tween.TRANS_BACK

func _ready() -> void:
	for button in buttons:
		_connect_button(button)

func _connect_button(button: Button) -> void:
	button.mouse_entered.connect(activate_button.bind(button.get_path()))
	button.mouse_exited.connect(deactivate_button.bind(button.get_path()))
	button.button_down.connect(pressed_button.bind(button.get_path()))
	button.button_up.connect(unpressed_button.bind(button.get_path()))

func add_button(button: Button) -> void:
	if button not in buttons:
		buttons.append(button)
		_connect_button(button)

func activate_button(button: NodePath) -> void:
	var button_node = get_node(button)
	if button_node:
		button_node.pivot_offset_ratio = Vector2(0.5,0.5)
		create_tween().set_trans(transition).tween_property(button_node, "scale", hover_scale, anim_time)

func deactivate_button(button: NodePath) -> void:
	var button_node = get_node(button)
	if button_node:
		button_node.pivot_offset_ratio = Vector2(0.5,0.5)
		create_tween().set_trans(transition).tween_property(button_node, "scale", Vector2.ONE, anim_time)

func pressed_button(button: NodePath) -> void:
	var button_node = get_node(button)
	if button_node:
		button_node.pivot_offset_ratio = Vector2(0.5,0.5)
		create_tween().set_trans(transition).tween_property(button_node, "scale", press_scale, anim_time)

func unpressed_button(button: NodePath) -> void:
	var button_node = get_node(button)
	if button_node:
		button_node.pivot_offset_ratio = Vector2(0.5,0.5)
		create_tween().set_trans(transition).tween_property(button_node, "scale", hover_scale, anim_time)
