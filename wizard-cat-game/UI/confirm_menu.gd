extends CenterContainer

@export var button_tween: ButtonTween
@export var pause_rect: ColorRect
@export var label = Label
var action: Callable

func _ready() -> void:
	SceneLoader.confirmation.connect(open)

func _on_confirm_button_pressed() -> void:
	button_tween.deactivate()
	action.call()

func open(message: String, new_action: Callable) -> void:
	button_tween.activate()
	action = new_action
	label.text = message
	get_tree().current_scene.set_deferred("pausable", false)
	get_tree().set_deferred("paused", true)
	pause_rect.show()
	show()

func close() -> void:
	var tree := get_tree()
	tree.create_timer(0.1).timeout.connect(tree.current_scene.set_deferred.bind("pausable", true))
	tree.set_deferred("paused", false)
	pause_rect.hide()
	hide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		close()
