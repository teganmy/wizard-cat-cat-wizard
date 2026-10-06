class_name ButtonTween
extends Node

@export var anim_time: float = 0.2
@export var hover_scale: Vector2 = Vector2(1.05, 1.05)
@export var press_scale: Vector2 = Vector2(0.9,0.9)
@export var transition := Tween.TRANS_BACK

func activate_button(button: NodePath) -> void:
	var button_node = get_node(button)
	button_node.pivot_offset_ratio = Vector2(0.5,0.5)
	get_tree().create_tween().set_trans(transition).tween_property(button_node, "scale", hover_scale, anim_time)

func deactivate_button(button: NodePath) -> void:
	var button_node = get_node(button)
	button_node.pivot_offset_ratio = Vector2(0.5,0.5)
	get_tree().create_tween().set_trans(transition).tween_property(button_node, "scale", Vector2.ONE, anim_time)

func pressed_button(button: NodePath) -> void:
	var button_node = get_node(button)
	button_node.pivot_offset_ratio = Vector2(0.5,0.5)
	get_tree().create_tween().set_trans(transition).tween_property(button_node, "scale", press_scale, anim_time)

func unpressed_button(button: NodePath) -> void:
	var button_node = get_node(button)
	button_node.pivot_offset_ratio = Vector2(0.5,0.5)
	get_tree().create_tween().set_trans(transition).tween_property(button_node, "scale", hover_scale, anim_time)
