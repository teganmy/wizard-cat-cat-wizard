extends Node2D

func _on_new_game_button_pressed() -> void:
	PlayerState.reset()
	SceneLoader.change_to_home()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
