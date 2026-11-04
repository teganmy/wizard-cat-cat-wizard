extends Control

@export var button_container: Container
@export var button_tween: ButtonTween
var levels: Array[LevelDef] = []
var buttons: Array[Button] = []
signal level_selected(def: LevelDef)

func _ready() -> void:
	hide()
	levels = LevelLoader.levels
	for level in levels:
		var button = Button.new()
		button.text = level.name
		button_container.add_child(button)
		button_tween.add_button(button)
		button.pressed.connect(level_selected.emit.bind(level))
		button.pressed.connect(close)
		buttons.append(button)

func open() -> void:
	for button in buttons.slice(0, LevelLoader.level_pointer):
		button.set_disabled(false)
	for button in buttons.slice(LevelLoader.level_pointer):
		button.set_disabled(true)
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
