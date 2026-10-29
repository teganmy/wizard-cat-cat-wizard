extends Control

@export var button_container: Container
@export var button_tween: ButtonTween
var levels: Array[LevelDef] = []
signal level_selected(def: LevelDef)

func _ready() -> void:
	hide()
	for file_name in ResourceLoader.list_directory("res://levels/defs"):
		var file = ResourceLoader.load("res://levels/defs/%s" % file_name)
		if file is LevelDef:
			levels.append(file)
	levels.sort_custom(func(one: LevelDef, two: LevelDef): return one.ordering < two.ordering)
	for level in levels:
		var button = Button.new()
		button.text = level.name
		button_container.add_child(button)
		button_tween.add_button(button)
		button.pressed.connect(level_selected.emit.bind(level))
		button.pressed.connect(close)

func open() -> void:
	get_tree().current_scene.set_deferred("pausable", false)
	get_tree().set_deferred("paused", true)
	show()

func close() -> void:
	var tree := get_tree()
	tree.create_timer(0.1).timeout.connect(tree.current_scene.set_deferred.bind("pausable", true))
	tree.set_deferred("paused", false)
	hide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		close()


func _on_cancel_button_pressed() -> void:
	close()
