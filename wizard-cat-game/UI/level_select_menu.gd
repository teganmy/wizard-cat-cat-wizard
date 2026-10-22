extends Control

@export var button_container: Container
@export var button_tween: ButtonTween
var levels: Array[String] = []
signal level_selected(num: int)

func _ready() -> void:
	hide()
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
			button_tween.add_button(button)
			button.pressed.connect(level_selected.emit.bind(num.to_int()))
			button.pressed.connect(close)

func open() -> void:
	LevelState.set_deferred("pausable", false)
	get_tree().set_deferred("paused", true)
	show()

func close() -> void:
	get_tree().create_timer(0.1).timeout.connect(LevelState.set_deferred.bind("pausable", true))
	get_tree().set_deferred("paused", false)
	hide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		close()
