extends Node

var current_save: String
var save_folder: String = "user://save/"
var save_files: Array[String] = []

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(save_folder):
		DirAccess.make_dir_absolute(save_folder)
	var dir := DirAccess.open(save_folder)
	for file in dir.get_files():
		if file.get_extension() == "json":
			save_files.append(file)
	save_files.sort_custom(_sort_by_date)
	current_save = save_files[0]

func save_current() -> void:
	save(current_save)

func load_current() -> void:
	load_save(current_save)

func save(file_to_save: String) -> void:
	if FileAccess.file_exists(save_folder.path_join(file_to_save)):
		print("Saving %s...", file_to_save)
		var file := FileAccess.open(save_folder.path_join(file_to_save), FileAccess.WRITE)
		var last_access: String = JSON.stringify({"last_access": Time.get_datetime_string_from_system(true)})
		file.store_line(last_access)
		for node in get_tree().get_nodes_in_group("Persistent"):
			if node.has_method("save"):
				var save_data = node.call("save")
				var json_string = JSON.stringify(save_data)
				file.store_line(json_string)
		current_save = file_to_save
		file.close()

func load_save(save_to_load: String) -> void:
	if FileAccess.file_exists(save_folder.path_join(save_to_load)):
		print("Loading %s..." % save_to_load)
		var file := FileAccess.open(save_folder.path_join(save_to_load), FileAccess.READ)
		var _date: String = file.get_line()
		var line: String = file.get_line()
		while line:
			var data: Dictionary = JSON.parse_string(line)
			if not data:
				continue
			var node: Node
			if data["scene_path"]:
				get_node(data["path"]).queue_free()
				node = ResourceLoader.load(data["scene_path"]).instantiate()
				get_node(data["parent"]).add_child(node)
			else:
				node = get_node(data["path"])
			for key in data.keys():
				if key in ["scene_path", "path", "parent"]:
					continue
				node.set(key, data[key])
			line = file.get_line()
		current_save = save_to_load
		file.close()

func change_save_file(filename: String) -> void:
	if filename not in save_files:
		add_save_file(filename)
	current_save = filename

func get_save_files() -> Array[String]:
	return save_files

func add_save_file(filename: String) -> void:
	if filename not in save_files:
		var file = FileAccess.open(save_folder.path_join(filename), FileAccess.WRITE)
		file.store_line(JSON.stringify({"last_access": Time.get_datetime_string_from_system(true)}))
		save_files.append(file.get_path())

func get_last_access(filename: String) -> String:
	if filename in save_files:
		var file = FileAccess.open(save_folder.path_join(filename), FileAccess.READ)
		if not file:
			return ""
		var dict = JSON.parse_string(file.get_line())
		file.close()
		if not dict:
			return ""
		if "last_access" in dict.keys():
			return dict["last_access"]
	return ""

func get_latest_save() -> String:
	save_files.sort_custom(_sort_by_date)
	return save_files[0]

## True if save1 should be before save2, e.g. save1 is *more recent*
func _sort_by_date(save1: String, save2: String) -> bool:
	var date1 = Time.get_datetime_dict_from_datetime_string(get_last_access(save1), false)
	var date2 = Time.get_datetime_dict_from_datetime_string(get_last_access(save2), false)
	for key in ["year", "month", "day", "hour", "second"]:
		if date1[key] > date2[key]:
			return true
	return false
