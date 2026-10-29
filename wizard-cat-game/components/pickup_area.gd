class_name PickupArea
extends Area2D

signal picked_up(value: int)
@export var health: Health
@export var secondary_shooter: AreaShooter

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Loot and not body.is_grabbed():
		if body.type.heal_amount > 0 and health.current >= health.max_health:
			return
		body.grab(self)
		body.picked_up.connect(_on_loot_picked_up.bind(body.type))

func _on_loot_picked_up(value: int, type: LootType) -> void:
	if type.heal_amount > 0:
		health.heal(type.heal_amount)
	elif type.attack:
		secondary_shooter.configure(type.attack.bullet_type, type.attack.firing_pattern)
	elif type.fire_rate_multiplier != 1.0:
		PlayerState.apply_fire_rate_boost(type.fire_rate_multiplier, type.fire_rate_duration)
	else:
		picked_up.emit(value)
