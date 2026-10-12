class_name Lootable
extends Node2D

@export var loot_table: Array[WeightedLoot]
var loot_scene: PackedScene = preload("res://loot.tscn")
@export var amount: int = 1

func generate_loot(location: Vector2 = Vector2.ZERO) -> void:
	for _i in range(amount):
		var new_loot = roll_loot()
		new_loot.global_position = to_global(location)
		if new_loot.has_method("apply_central_impulse"):
			new_loot.apply_central_impulse(Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * 75)
		get_tree().current_scene.add_child(new_loot)

func roll_loot() -> Loot:
	var rand = randf()
	for loot in loot_table:
		if rand <= loot.weight:
			var new_loot = loot_scene.instantiate()
			new_loot.type = loot.type
			return new_loot
	assert(false, "Should never be reached")
	return null
