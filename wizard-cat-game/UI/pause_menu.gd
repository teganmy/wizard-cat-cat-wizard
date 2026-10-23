extends CenterContainer

var paused: bool = false
@export var pause_rect: ColorRect

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause.call_deferred()

func toggle_pause() -> void:
	if LevelState.pausable:
		paused = not paused
		get_tree().paused = paused
		visible = paused
		pause_rect.visible = paused

func _ready() -> void:
	hide()

func _on_resume_button_pressed() -> void:
	toggle_pause.call_deferred()

func _on_quit_button_pressed() -> void:
	toggle_pause.call_deferred()
	SceneLoader.change_to_menu.call_deferred(true)

func _on_home_button_pressed() -> void:
	toggle_pause.call_deferred()
	SceneLoader.change_to_home.call_deferred(true)
