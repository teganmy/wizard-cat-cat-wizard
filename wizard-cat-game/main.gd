extends Node2D

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
