extends Control

@export var money_label: Label
@export var tutorial_popup: Popup
@export var pause_rect: ColorRect
@export var hint_label: Label

var hint_tween: Tween


func _ready() -> void:
	show()
	PlayerState.currency_changed.connect(_on_currency_changed)
	_on_currency_changed(PlayerState.currency)
	if PlayerState.player_is_new:
		tutorial_popup.popup_centered()
		get_tree().set_deferred("paused", true)
		pause_rect.show()
		PlayerState.player_is_new = false
	else:
		get_tree().current_scene.enter()
	hint_label.hide()
	hint_label.modulate.a = 0.0

func _on_currency_changed(new: int) -> void:
	money_label.text = "$%s" % new

func _on_tutorial_popup_popup_hide() -> void:
	get_tree().set_deferred("paused", false)
	pause_rect.hide()
	get_tree().current_scene.enter()

func show_hint(text: String) -> void:
	if hint_tween and hint_tween.is_running():
		hint_tween.kill()
	hint_tween = create_tween()
	hint_label.text = text
	hint_label.show()
	hint_tween.tween_property(hint_label, "modulate:a", 1.0, 0.2)

func hide_hint() -> void:
	if hint_tween and hint_tween.is_running():
		hint_tween.kill()
	hint_tween = create_tween()
	hint_tween.tween_property(hint_label, "modulate:a", 0.0, 0.2)
	await hint_tween.finished
	hint_label.hide()

func timed_hint(text: String, time: float) -> void:
	show_hint(text)
	await get_tree().create_timer(time).timeout
	hide_hint()
