extends StaticBody2D

@export var level_select: Control
@export var portal: StaticBody2D
@export var label: Label
var tween: Tween


func _ready() -> void:
	level_select.level_selected.connect(func(level: int): portal.level = level; portal.lock.unlock())
	label.modulate.a = 0.0

func _on_interaction_area_interact() -> void:
	level_select.open()


func _on_interaction_area_body_entered(_body: Node2D) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.1)


func _on_interaction_area_body_exited(_body: Node2D) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.1)
