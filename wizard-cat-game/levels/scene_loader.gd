extends Node

func change_to_home() -> void:
	get_tree().set_deferred("paused", false)
	LevelState.exit()
	get_tree().change_scene_to_file.call_deferred("res://levels/home_base.tscn")

func change_to_level(level: int) -> void:
	get_tree().set_deferred("paused", false)
	var filename = "res://levels/level_%s.tscn" % level
	LevelState.exit()
	if ResourceLoader.exists(filename):
		get_tree().change_scene_to_file.call_deferred(filename)

func change_to_menu() -> void:
	get_tree().set_deferred("paused", false)
	LevelState.exit()
	get_tree().change_scene_to_file.call_deferred("res://main.tscn")
