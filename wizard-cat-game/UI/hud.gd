extends Control

@onready var money_label := $MarginContainer/MoneyLabel

func _ready() -> void:
	PlayerState.currency_changed.connect(_on_currency_changed)
	if PlayerState.player_is_new:
		$TutorialPopup.popup_centered()
		get_tree().set_deferred("paused", true)
		$PauseRect.show()
		PlayerState.player_is_new = false
	else:
		LevelState.enter()
	
func _on_currency_changed(new: int) -> void:
	money_label.text = "$%s" % new

func _on_tutorial_popup_popup_hide() -> void:
	get_tree().set_deferred("paused", false)
	$PauseRect.hide()
	LevelState.enter()
