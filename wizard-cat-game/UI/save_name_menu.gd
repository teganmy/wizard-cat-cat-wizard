extends Control

@export var line_edit: LineEdit
@export var error_label: Label

signal save_named(name: String)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("confirm_button"):
		accept()
	elif Input.is_action_just_pressed("ui_cancel"):
		close()

func _ready() -> void:
	hide()

func open() -> void:
	show()
	line_edit.grab_focus()

func accept() -> void:
	var text = line_edit.text
	if not text:
		error_label.show()
		return
	text = text.to_snake_case() + ".json"
	print(text)
	if not text.is_valid_filename():
		error_label.show()
		return
	save_named.emit(text)

func close() -> void:
	line_edit.clear()
	hide()
