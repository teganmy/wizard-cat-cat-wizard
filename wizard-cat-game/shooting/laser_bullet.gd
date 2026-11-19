extends RayCast2D

@export var hit_range: float = 500
@export var hit_delay: float = 1.0
@export var life_timer: Timer
@export var beam_thickness: float = 200
@export var color_rect: ColorRect

var type: BulletType
var damage
var follow: Node2D
var seek_target: Callable

func _ready() -> void:
	collision_mask = type.hitbox_mask
	damage = type.damage
	var tween = create_tween()
	var adjust_progress: Callable = func(value: float): color_rect.material.set_shader_parameter("progress", value)
	tween.tween_method(adjust_progress, 0.0, 1.0, 0.2)
	tween.tween_method(adjust_progress, 1.0, 0.0, 0.2).set_delay(type.lifetime - 0.4)
	life_timer.start(type.lifetime)

func _on_life_timer_timeout() -> void:
	queue_free()

func _physics_process(_delta: float) -> void:
	if is_instance_valid(follow):
		global_position = follow.global_position
	var target_global: Vector2 = seek_target.call()
	target_position = to_local(target_global).normalized() * hit_range
	force_raycast_update()
	var end_global: Vector2 = to_global(target_position)
	if is_colliding():
		end_global = get_collision_point()
		var collider = get_collider()
		if collider is Hurtbox:
			collider.take_damage(damage, hit_delay)
	var end_local: Vector2 = to_local(end_global)
	var angle: float = end_local.angle()
	color_rect.size = Vector2(end_local.length(), beam_thickness)
	color_rect.rotation = angle
	color_rect.position = Vector2(0.0, -beam_thickness * 0.5).rotated(angle)
