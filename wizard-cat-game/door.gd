extends StaticBody2D

@onready var collision_shape = $CollisionShape2D
@onready var lock = $Lock

func _on_lock_locked() -> void:
	print("CLICK!")
	collision_shape.set_deferred("disabled", false)

func _on_lock_unlocked() -> void:
	print("CLACK!")
	collision_shape.set_deferred("disabled", true)

func _ready() -> void:
	collision_shape.set_deferred("disabled", not lock.is_locked())
