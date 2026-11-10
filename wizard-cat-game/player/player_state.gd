extends Node
var fire_rate_multiplier: float = 1.0
var _boost_timer: Timer

const BASE_POTIONS := 3
var max_potions: int:
	get:
		return BASE_POTIONS + upgrade_level("potion_slots")
var upgrades: Dictionary = {}
var potions: Array[LootType] = []
var secondary: SecondaryAttack

signal potions_changed
signal upgrades_changed
signal secondary_changed(type: SecondaryAttack)

var current_health: int:
	set(new):
		new = min(new, max_health)
		new = max(new, 0)
		current_health_changed.emit(new)
		current_health = new
var max_health: int:
	set(new):
		new = max(new, 0)
		max_health_changed.emit(new)
		max_health = new
var currency: int = 0:
	set(new):
		new = max(new, 0)
		currency_changed.emit(new)
		currency = new
var player_is_new: bool = true
var secondary_path: String:
	get:
		return secondary.resource_path if secondary else ""
	set(path):
		set_secondary(load(path) if path != "" else null)

var potion_paths: Array:
	get:
		return potions.map(func(p: LootType): return p.resource_path)
	set(paths):
		potions.clear()
		for path in paths:
			potions.append(load(path))
		potions_changed.emit()
		
signal current_health_changed(new: int)
signal max_health_changed(new: int)
signal currency_changed(new: int)
signal fire_rate_boost_changed(multiplier: float)

func _ready() -> void:
	add_to_group("Persistent")
	_boost_timer = Timer.new()
	_boost_timer.one_shot = true
	_boost_timer.timeout.connect(clear_fire_rate_boost)
	add_child(_boost_timer)
	
func apply_fire_rate_boost(multiplier: float, duration: float) -> void:
	fire_rate_multiplier = multiplier
	_boost_timer.start(duration)
	fire_rate_boost_changed.emit(multiplier)
func clear_fire_rate_boost() -> void:
	fire_rate_multiplier = 1.0
	_boost_timer.stop()
	fire_rate_boost_changed.emit(1.0)
	
func reset() -> void:
	current_health = 0
	max_health = 0
	currency = 0
	clear_fire_rate_boost()
	player_is_new = true
	potions.clear()
	secondary = null

func save() -> Dictionary:
	return {
		"path": get_path(),
		"parent": get_parent(),
		"scene_path": scene_file_path,
		"current_health": current_health,
		"max_health": max_health,
		"currency": currency,
		#"potions": potions.map(func(p: LootType): return p.resource_path),
		"player_is_new": player_is_new,
		"secondary_path": secondary_path,
		"potion_paths": potion_paths,
		"upgrades": upgrades,
	}

func add_potion(type: LootType) -> bool:
	if potions.size() >= max_potions:
		return false
	potions.append(type)
	potions_changed.emit()
	return true
	
func selected() -> LootType:
	if potions.size() > 0:
		return potions.front()
	return null
	
func consume_selected() -> void:
	potions.pop_front()
	potions_changed.emit()

func cycle_potion() -> void:
	if potions.size() > 1:
		potions.push_back(potions.pop_front())
		potions_changed.emit()

func set_secondary(type: SecondaryAttack) -> void:
	secondary = type
	secondary_changed.emit(type)
	
func upgrade_level(id: String) -> int:
	return int(upgrades.get(id, 0))
	
func add_upgrade(id: String) -> void:
	upgrades[id] = upgrade_level(id) + 1
	if id == "max_health":
		max_health += 1
	upgrades_changed.emit()
	
