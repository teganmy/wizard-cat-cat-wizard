extends Control

@export var button_container: VBoxContainer
@export var button_tween: ButtonTween
var buttons: Array[Button] = []

signal selected(save: String)

func _ready() -> void:
	hide()

func open() -> void:
	for file in Save.get_save_files():
		var button = Button.new()
		button.text = file.get_file().get_basename().capitalize()
		button.pressed.connect(save_select.bind(file))
		buttons.append(button)
		button_container.add_child(button)
		button_tween.add_button(button)
	show()

func close() -> void:
	hide()
	for button in buttons:
		button_tween.remove_button(button)
		button.queue_free()
	buttons.clear()

func save_select(save: String) -> void:
	Save.load_save(save)
	selected.emit(save)
	close()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		close()

func _on_cancel_button_pressed() -> void:
	close()
