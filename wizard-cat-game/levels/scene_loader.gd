extends Node

signal confirmation(text: String, action: Callable)

var home_base: PackedScene = preload("res://levels/home_base.tscn")
var main_menu: PackedScene = preload("res://main.tscn")

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
	var tree := get_tree()
	tree.set_deferred("paused", false)
	var current := get_tree().current_scene
	if current is Level and current.level_def:
		#var kept_potions: Array = PlayerState.potion_paths
		Save.load_current()
		#PlayerState.potion_paths = kept_potions
		#Save.save_current()
	elif current is Level:
		Save.save_current()
	if tree.current_scene.has_method("exit"):
		tree.current_scene.exit()
	var basename: String = file.get_file().get_basename()
	if basename == "main":
		tree.change_scene_to_packed(main_menu)
	elif basename == "home_base":
		tree.change_scene_to_packed(home_base)
	tree.change_scene_to_file.call_deferred(file)
