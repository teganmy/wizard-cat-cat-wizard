extends CenterContainer

func _ready() -> void:
	LevelState.exit_tried.connect(_on_level_exited)

func _on_level_exited() -> void:
	show()

func _on_cancel_button_pressed() -> void:
	hide()

func _on_confirm_button_pressed() -> void:
	SceneLoader.change_to_home()
