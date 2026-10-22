class_name LabelPopup
extends Label

@export var interaction_area: InteractionArea
var tween: Tween

func _ready() -> void:
	modulate.a = 0.0
	interaction_area.body_entered.connect(popup.unbind(1))
	interaction_area.body_exited.connect(close.unbind(1))

func popup() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.1)

func close() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.1)
