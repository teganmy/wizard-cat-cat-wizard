class_name Enemy
extends CharacterBody2D
signal died

@export var health: Health
@export var shooter: Node2D
@export_group("Shooting")
@export var fire_interval: float = 1.2
@export var detection_range: float = 400.0
@export var target_group: StringName = &"player"

var target: Node2D


func _ready() -> void:
	health.changed.connect(_on_health_changed)
	health.died.connect(_on_died)

	var fire_timer := Timer.new()
	fire_timer.wait_time = fire_interval
	fire_timer.autostart = true
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	add_child(fire_timer)


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(target):
		target = get_tree().get_first_node_in_group(target_group) as Node2D


func _on_fire_timer_timeout() -> void:
	if not is_instance_valid(target):
		return
	if global_position.distance_to(target.global_position) > detection_range:
		return
	shoot()


func shoot() -> void:
	var bullet: Node2D = shooter.fire(target.global_position)
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = shooter.global_position


func _on_health_changed(current: int) -> void:
	if current < health.max_health:
		_flash()


func _on_died() -> void:
	died.emit()
	$Lootable.generate_loot()
	queue_free()


func _flash() -> void:
	modulate = Color(1, 0.4, 0.4)
	create_tween().tween_property(self, "modulate", Color.WHITE, 0.15)
