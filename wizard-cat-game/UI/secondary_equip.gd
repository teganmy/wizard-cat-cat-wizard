extends Control

@export var secondary_list: GridContainer

func _ready() -> void:
	hide()

func open() -> void:
	secondary_list.reload()
	get_tree().current_scene.set_deferred("pausable", false)
	get_tree().set_deferred("paused", true)
	show()

func close() -> void:
	var tree := get_tree()
	tree.create_timer(0.1).timeout.connect(tree.current_scene.set_deferred.bind("pausable", true))
	tree.set_deferred("paused", false)
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close()
