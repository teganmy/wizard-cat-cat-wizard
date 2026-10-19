extends StaticBody2D

var opened: bool = false
@export var lock: Lock
@export var loot_table_override: Array[WeightedLoot]
@export var max_loot_override: int
@export var min_loot_override: int
@export var lootable: Lootable
@export var sprite: Sprite2D

func _on_interaction_area_interact() -> void:
	if not opened and not lock.is_locked():
		lootable.generate_loot($SpawnMarker.position)
		opened = true
		sprite.modulate = Color.DARK_GRAY
	elif lock.is_locked():
		var label := $LockedLabel
		if label:
			label.scale = Vector2(0.75,0.75)
			var tween = label.create_tween()
			tween.tween_property(label, "modulate:a", 1.0, 0.1)
			tween.set_trans(Tween.TRANS_BACK).parallel().tween_property(label, "scale", Vector2(1.0, 1.0), 0.1)
			tween.tween_property(label, "modulate:a", 0.0, 0.1).set_delay(1.0)

func _on_interaction_area_body_entered(_body: Node2D) -> void:
	if not opened:
		create_tween().tween_property(sprite, "modulate", Color.YELLOW, 0.1)

func _on_interaction_area_body_exited(_body: Node2D) -> void:
	if not opened:
		create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.1)
	else:
		sprite.modulate = Color.DARK_GRAY

func _ready() -> void:
	if loot_table_override:
		lootable.loot_table = loot_table_override
	if max_loot_override:
		lootable.max_amount = max_loot_override
	if min_loot_override:
		lootable.min_amount = min_loot_override
