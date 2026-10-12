class_name PickupArea
extends Area2D

signal picked_up(value: int)

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Loot and not body.is_grabbed():
		body.grab(self)
		body.picked_up.connect(_on_loot_picked_up)

func _on_loot_picked_up(value: int) -> void:
	picked_up.emit(value)
