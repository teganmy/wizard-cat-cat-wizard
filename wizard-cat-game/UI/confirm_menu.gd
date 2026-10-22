extends CenterContainer

@export var pause_rect: ColorRect

func _ready() -> void:
	LevelState.exit_tried.connect(open)	

func _on_confirm_button_pressed() -> void:
	SceneLoader.change_to_home()

func open() -> void:
	LevelState.set_deferred("pausable", false)
	get_tree().set_deferred("paused", true)
	pause_rect.show()
	show()

func close() -> void:
	get_tree().create_timer(0.1).timeout.connect(LevelState.set_deferred.bind("pausable", true))
	get_tree().set_deferred("paused", false)
	pause_rect.hide()
	hide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		close()
