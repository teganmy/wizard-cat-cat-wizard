extends Node2D

@export var save_load_menu: Control

func _ready() -> void:
	save_load_menu.selected.connect(_on_save_selected)

func _on_new_game_button_pressed() -> void:
	PlayerState.reset()
	SceneLoader.change_to_home()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_continue_button_pressed() -> void:
	PlayerState.reset()
	Save.load_current()
	SceneLoader.change_to_home.call_deferred()

func _on_load_button_pressed() -> void:
	save_load_menu.open()

func _on_save_selected(save: String) -> void:
	PlayerState.reset()
	Save.load_save(save)
	SceneLoader.change_to_home.call_deferred()
