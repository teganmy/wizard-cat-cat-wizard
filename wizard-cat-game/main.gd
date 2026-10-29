extends Node2D

@export var save_load_menu: Control
@export var save_name_menu: Control

func _ready() -> void:
	save_load_menu.selected.connect(_on_save_selected)
	save_name_menu.save_named.connect(_on_save_named)

func _on_new_game_button_pressed() -> void:
	save_name_menu.open()
	#PlayerState.reset()
	#SceneLoader.change_to_home()

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

func _on_save_named(save_name: String) -> void:
	PlayerState.reset()
	Save.add_save_file(save_name)
	Save.save(save_name)
	SceneLoader.change_to_home.call_deferred()
