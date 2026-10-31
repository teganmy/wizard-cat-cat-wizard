extends Control

@export var money_label: Label
@export var tutorial_popup: Popup
@export var pause_rect: ColorRect

func _ready() -> void:
	PlayerState.currency_changed.connect(_on_currency_changed)
	_on_currency_changed(PlayerState.currency)
	if PlayerState.player_is_new:
		tutorial_popup.popup_centered()
		get_tree().set_deferred("paused", true)
		pause_rect.show()
		PlayerState.player_is_new = false
	else:
		get_tree().current_scene.enter()
	
func _on_currency_changed(new: int) -> void:
	money_label.text = "$%s" % new

func _on_tutorial_popup_popup_hide() -> void:
	get_tree().set_deferred("paused", false)
	pause_rect.hide()
	get_tree().current_scene.enter()
