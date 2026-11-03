extends Area2D

@export var type: BulletType
@export var payload: PackedScene
var speed: float = 0.0
var dir: Vector2 = Vector2.ZERO
@export_group("Wiring")
@export var particles: GPUParticles2D
@export var sprite: Sprite2D
@export var hitbox: Hitbox
@export var lifetime_timer: Timer
var cleaned: bool

func _ready() -> void:
	sprite.texture = type.sprite
	particles.texture = type.particle_texture
	sprite.modulate = type.modulate
	particles.modulate = type.particle_modulate
	speed = type.speed 
	lifetime_timer.wait_time = type.lifetime
	hitbox.damage = type.damage
	payload = type.payload
	if type.collision_layer:
		collision_layer = type.collision_layer
	if type.collision_mask:
		collision_mask = type.collision_mask
	if type.hitbox_layer:
		hitbox.collision_layer = type.hitbox_layer
	if type.hitbox_mask:
		hitbox.collision_mask = type.hitbox_mask
	scale = type.scale
	if particles.material:
		particles.material.direction = Vector3(dir.x, dir.y, 0.0)
	lifetime_timer.start()

func _physics_process(delta: float) -> void:
	translate(get_speed() * dir * delta)

func get_speed() -> float:
	if type.speed_curve:
		return type.speed_curve.sample_baked((type.lifetime - lifetime_timer.time_left) / type.lifetime) * speed
	else:
		return speed

func _on_body_entered(_body: Node2D) -> void:
	_clean_up.call_deferred()

func _on_hitbox_landed() -> void:
	_clean_up.call_deferred()

func _on_lifetime_timer_timeout() -> void:
	_clean_up.call_deferred()

func _activate_payload() -> void:
	if payload:
		var node = payload.instantiate()
		node.global_position = self.global_position
		get_tree().current_scene.add_child.call_deferred(node)
		print(node)

func _clean_up() -> void:
	if not cleaned:
		_activate_payload()
		cleaned = true
		dir = Vector2.ZERO
		sprite.hide()
		particles.amount_ratio = 0.0
		hitbox.monitoring = false
		particles.finished.connect(queue_free)
