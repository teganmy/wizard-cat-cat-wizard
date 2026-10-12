extends MarginContainer

@onready var money_label := $MoneyLabel

func _ready() -> void:
	PlayerState.currency_changed.connect(_on_currency_changed)
	
func _on_currency_changed(new: int) -> void:
	money_label.text = "$%s" % new
