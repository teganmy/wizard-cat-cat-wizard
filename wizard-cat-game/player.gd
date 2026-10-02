extends CharacterBody2D

@export var speed: float = 100

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	velocity = speed * dir
	if Input.is_action_just_pressed("fire"):
		var bullet = load("res://bullet.tscn").instantiate()
		bullet.dir =  global_position.direction_to(get_global_mouse_position())
		bullet.position = global_position
		get_parent().add_child(bullet)
	move_and_slide()


func _on_health_changed(current: int) -> void:
	print("Player health: ", current)

func _on_health_died() -> void:
	print("Player died")
	queue_free()
