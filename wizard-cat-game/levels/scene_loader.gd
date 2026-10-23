extends Node

signal confirmation(text: String, action: Callable)

func change_to_home(confirm: bool = false) -> void:
	if confirm:
		confirmation.emit("Really go home?", change_to_home)
		return
	get_tree().set_deferred("paused", false)
	LevelState.exit()
	get_tree().change_scene_to_file.call_deferred("res://levels/home_base.tscn")

func change_to_level(level: LevelDef, confirm: bool = false) -> void:
	if confirm:
		confirmation.emit("Really go to %s?" % level.name, change_to_level.bind(level))
		return
	get_tree().set_deferred("paused", false)
	LevelState.exit()
	get_tree().change_scene_to_file.call_deferred(level.file)

func change_to_menu(confirm: bool = false) -> void:
	if confirm:
		confirmation.emit("Really quit?", change_to_menu)
		return
	get_tree().set_deferred("paused", false)
	LevelState.exit()
	get_tree().change_scene_to_file.call_deferred("res://main.tscn")
