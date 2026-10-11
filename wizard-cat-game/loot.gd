
extends RigidBody2D

@export var value: int = 1
@onready var sprite := $Sprite2D

func pick_up() -> int:
	queue_free()
	return value

func _ready() -> void:
	var tween := create_tween().set_loops(0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "offset:y", 5, 0.75)
	tween.tween_property(sprite, "offset:y", -5, 0.75)
