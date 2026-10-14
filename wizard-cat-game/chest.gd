extends StaticBody2D

var opened: bool = false
@export var lock: Lock
@export var loot_table_override: Array[WeightedLoot]
@export var loot_amount_override: int
@onready var sprite := $Sprite2D

func _on_interaction_area_interact() -> void:
	if not opened and lock and not lock.is_locked():
		$Lootable.generate_loot($SpawnMarker.position)
		opened = true
		sprite.modulate = Color.DARK_GRAY

func _on_interaction_area_body_entered(_body: Node2D) -> void:
	if not opened and lock and not lock.is_locked():
		create_tween().tween_property(sprite, "modulate", Color.YELLOW, 0.1)

func _on_interaction_area_body_exited(_body: Node2D) -> void:
	if not opened and lock and not lock.is_locked():
		create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.1)

func _ready() -> void:
	if loot_table_override:
		$Lootable.loot_table = loot_table_override
	if loot_amount_override:
		$Lootable.amount = loot_amount_override
