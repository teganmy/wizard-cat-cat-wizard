class_name Lootable
extends Node2D

@export var loot_table: Array[WeightedLoot]
@export var guaranteed_loot: Array[LootType]
var max_weight: float = 0
var loot_scene: PackedScene = preload("res://loot/loot.tscn")
@export var max_amount: int = 2
@export var min_amount: int = 1

func _ready() -> void:
	for i in loot_table:
		max_weight += i.weight

func generate_loot(location: Vector2 = Vector2.ZERO) -> void:
	var amount = randi_range(min_amount, max_amount)
	if not loot_table.is_empty() and _total_weight() > 0.0:
		for _i in range(amount):
			var new_loot = roll_loot()		
			new_loot.global_position = to_global(location)
			_apply_impulse(new_loot)
			get_tree().current_scene.add_child.call_deferred(new_loot)
	for type in guaranteed_loot:
		var new_loot = loot_scene.instantiate()
		new_loot.type = type
		new_loot.global_position = to_global(location)
		_apply_impulse(new_loot)
		get_tree().current_scene.add_child.call_deferred(new_loot)
		

func _apply_impulse(loot: Node2D) -> void:
	if loot.has_method("apply_central_impulse"):
			loot.apply_central_impulse(Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * 75)

func roll_loot() -> Loot:
	var rand := randf() * _total_weight()
	var cumulative := 0.0
	for loot in loot_table:
		cumulative += loot.weight
		if rand < cumulative:
			var new_loot = loot_scene.instantiate()
			new_loot.type = loot.type
			return new_loot
	var fallback = loot_scene.instantiate()
	fallback.type = loot_table.back().type
	return fallback
	
func _total_weight() -> float:
	var total := 0.0
	for entry in loot_table:
		total += entry.weight
	return total
