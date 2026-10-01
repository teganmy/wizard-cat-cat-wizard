extends CharacterBody2D

@export var speed: float = 100

func _physics_process(delta: float) -> void:
	var dir := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	velocity = speed * dir
	move_and_slide()
