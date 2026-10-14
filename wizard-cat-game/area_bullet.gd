extends Area2D

@export var dir: Vector2 = Vector2.ZERO
@export var speed: float = 500.0
@onready var particles := $GPUParticles2D

func ready() -> void:
	particles.material.direction = Vector3(dir.x, dir.y, 0.0)

func _physics_process(delta: float) -> void:
	translate(speed * dir * delta)

func _on_body_entered(_body: Node2D) -> void:
	_clean_up.call_deferred()

func _on_hitbox_landed() -> void:
	_clean_up.call_deferred()

func _clean_up() -> void:
	if get_tree():
		dir = Vector2.ZERO
		$Sprite2D.hide()
		particles.amount_ratio = 0.0
		$Hitbox.monitoring = false
		await get_tree().create_timer(2.0).timeout
	queue_free()
