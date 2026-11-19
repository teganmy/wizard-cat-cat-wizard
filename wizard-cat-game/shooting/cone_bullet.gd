extends Node2D

var type: BulletType
var follow: Node2D
var seek_target: Callable
var cone_direction: Vector2 = Vector2(0.0,1.0)
@export var hitbox: Hitbox
@export var particles: GPUParticles2D
@export var life_timer: Timer

func _ready() -> void:
	hitbox.damage = type.damage
	hitbox.collision_mask = type.hitbox_mask
	particles.modulate = type.particle_modulate
	life_timer.start(type.lifetime)

func _physics_process(_delta: float) -> void:
	if is_instance_valid(follow):
		global_position = follow.global_position
	if seek_target:
		var target_global: Vector2 = seek_target.call()
		var direction: Vector2 = target_global - global_position
		if not direction.is_zero_approx():
			global_rotation = direction.angle() - cone_direction.angle()



func _on_life_timer_timeout() -> void:
	queue_free()
