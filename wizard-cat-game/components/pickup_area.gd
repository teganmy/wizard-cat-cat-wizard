class_name PickupArea
extends Area2D

signal picked_up(value: int)
@export var health: Health
@export var secondary_shooter: AreaShooter
var _potions: int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Loot and not body.is_grabbed():
		var type: LootType = body.type
		if type.storable:
			if PlayerState.potions.size() + _potions >= PlayerState.max_potions:
				return
			_potions += 1
		elif not type.can_use(health):
			return
		body.grab(self)
		body.picked_up.connect(_on_loot_picked_up.bind(body.type))

func _on_loot_picked_up(value: int, type: LootType) -> void:
	if type.storable:
		_potions -= 1
		PlayerState.add_potion(type)
	elif not apply_effect(type):
		picked_up.emit(value)
	
func apply_effect(type: LootType) -> bool:
	if type.heal_amount > 0:
		health.heal(type.heal_amount)
	elif type.attack:
		secondary_shooter.configure(type.attack.bullet_type, type.attack.firing_pattern)
	elif type.fire_rate_multiplier != 1.0:
		PlayerState.apply_fire_rate_boost(type.fire_rate_multiplier, type.fire_rate_duration)
	else:
		return false
	return true
