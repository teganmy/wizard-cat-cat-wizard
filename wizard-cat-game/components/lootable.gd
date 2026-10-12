class_name Lootable
extends Node2D

@export var loot: PackedScene
@export var amount: int = 1
var opened: bool = false

func open(location: Vector2 = Vector2.ZERO) -> void:
	if not opened:
		opened = true
		print("Opened")
		for _i in range(amount):
			var new_loot = loot.instantiate()
			new_loot.global_position = to_global(location)
			if new_loot.has_method("apply_central_impulse"):
				new_loot.apply_central_impulse(Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * 100)
			get_tree().current_scene.add_child(new_loot)
