extends Control

@export var button_container: Container
var levels: Array[String] = []

func _ready() -> void:
	for file_name in ResourceLoader.list_directory("res://levels"):
		if file_name.begins_with("level_") and file_name.ends_with(".tscn"):
			levels.append(file_name)
	var regex := RegEx.create_from_string("\\d+")
	for level in levels:
		var num = regex.search(level).get_string()
		if num != "":
			var button = Button.new()
			button.text = num
			button_container.add_child(button)
			button.pressed.connect(SceneLoader.change_to_level.bind(num.to_int()))
		
