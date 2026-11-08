extends Camera2D

@export var decay: float = 60.0

var strength: float = 0.0

func shake(amount: float) -> void:
	strength = amount

func _process(delta: float) -> void:
	if strength <= 0.0:
		offset = Vector2.ZERO
		return
	offset = Vector2(randf_range(-strength, strength), randf_range(-strength, strength))
	strength = move_toward(strength, 0.0, decay * delta)
