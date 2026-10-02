extends CharacterBody2D

@export var speed: float = 100

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	velocity = speed * dir
	move_and_slide()


func _on_health_changed(current: int) -> void:
	print("Player health: ", current)

func _on_health_died() -> void:
	print("Player died")
	queue_free()
