extends CenterContainer

var paused: bool = false
@export var pause_rect: ColorRect

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause.call_deferred()

func toggle_pause() -> void:
	if LevelState.can_pause():
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
	get_tree().change_scene_to_file.call_deferred("res://main.tscn")
