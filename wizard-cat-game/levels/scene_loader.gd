extends Node

signal confirmation(text: String, action: Callable)

func change_to_home(confirm: bool = false) -> void:
	if confirm:
		confirmation.emit("Really go home?", change_to_file.bind("res://levels/home_base.tscn"))
		return
	change_to_file("res://levels/home_base.tscn")

func change_to_level(level: LevelDef, confirm: bool = false) -> void:
	if confirm:
		confirmation.emit("Really go to %s?" % level.name, change_to_file.bind(level.file))
		return
	change_to_file(level.file)

func change_to_menu(confirm: bool = false) -> void:
	if confirm:
		confirmation.emit("Really quit?", change_to_file.bind("res://main.tscn"))
		return
	else:
		change_to_file("res://main.tscn")

func change_to_file(file: String) -> void:
	get_tree().set_deferred("paused", false)
	LevelState.exit()
	get_tree().change_scene_to_file.call_deferred(file)
