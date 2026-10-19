extends StaticBody2D

@export var lock: Lock
@export var scene_to_load: PackedScene


func _on_interaction_area_interact() -> void:
	if not lock.is_locked():
		get_tree().change_scene_to_packed.call_deferred(scene_to_load)
