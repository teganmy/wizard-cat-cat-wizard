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
	change_save_file("test.json")
	save()
	for file in save_files:
		print(get_last_access(file))

func save() -> void:
	if current_save:
		var file := FileAccess.open(save_folder + current_save, FileAccess.WRITE)
		var last_access: String = JSON.stringify({"last_access": Time.get_datetime_string_from_system(true)})
		file.store_line(last_access)
		for node in get_tree().get_nodes_in_group("Persistent"):
			if node.has_method("save"):
				var save_data = node.call("save")
				var json_string = JSON.stringify(save_data)
				file.store_line(json_string)
		file.close()

func load_save() -> void:
	if current_save:
		var file := FileAccess.open(save_folder + current_save, FileAccess.READ)
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
			line = file.get_line()

func change_save_file(filename: String) -> void:
	if filename not in save_files:
		add_save_file(filename)
	current_save = filename

func get_save_files() -> Array[String]:
	return save_files

func add_save_file(filename: String) -> void:
	if filename not in save_files:
		var file = FileAccess.open(save_folder + filename, FileAccess.WRITE).get_path()
		save_files.append(file)

func get_last_access(filename: String) -> String:
	if filename in save_files:
		var file = FileAccess.open(save_folder + filename, FileAccess.READ)
		if not file:
			return ""
		var dict = JSON.parse_string(file.get_line())
		file.close()
		if not dict:
			return ""
		if "last_access" in dict.keys():
			return dict["last_access"]
	return ""
