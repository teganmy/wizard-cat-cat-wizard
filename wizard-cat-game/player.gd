extends CharacterBody2D

@export var speed: float = 100
@onready var shooter := $AreaShooter
var last_dir: Vector2 = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	if dir != last_dir:
		get_tree().create_tween().set_trans(Tween.TRANS_QUAD).tween_property(self, "velocity", speed * dir, 0.25)
		last_dir = dir
	if Input.is_action_just_pressed("fire"):
		add_sibling(shooter.fire(get_global_mouse_position()))
	move_and_slide()


func _on_health_changed(current: int) -> void:
	print("Player health: ", current)

func _on_health_died() -> void:
	print("Player died")
	queue_free()
