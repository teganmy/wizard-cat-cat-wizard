extends Node

var levels: Array[LevelDef] = []
var def_location: String = "res://levels/defs"
var level_pointer: int = 1

func _ready() -> void:
	add_to_group("Persistent")
	for file_name in ResourceLoader.list_directory(def_location):
		var file = ResourceLoader.load(def_location.path_join(file_name))
		if file is LevelDef:
			levels.append(file)
	levels.sort_custom(func(one: LevelDef, two: LevelDef): return one.ordering < two.ordering)

func get_unlocked_levels() -> Array[LevelDef]:
	return levels.slice(0, level_pointer)

func get_locked_levels() -> Array[LevelDef]:
	return levels.slice(level_pointer)

func unlock_next_level() -> void:
	level_pointer += 1

func is_unlocked(level: LevelDef) -> bool:
	var current: LevelDef = levels[level_pointer - 1]
	return level.ordering <= current.ordering

func is_current(level: LevelDef) -> bool:
	if level_pointer - 1 > levels.size():
		return levels[level_pointer - 1] == level
	else:
		return false

func reset() -> void:
	level_pointer = 1

func save() -> Dictionary:
	return {
		"path": get_path(),
		"parent": get_parent(),
		"scene_path": scene_file_path,
		"level_pointer": level_pointer
	}
