extends StaticBody2D

@export var lock: Lock
## The level the portal is to, or home base if empty
@export var level: LevelDef:
	set(new_level):
		level = new_level
		set_label()
@export var label: Label

func _ready() -> void:
	set_label()
	lock.unlocked.connect(set_label)
	lock.locked.connect(set_label)

func _on_interaction_area_interact() -> void:
	if not lock.is_locked():
		if level == null:
			LevelState.try_exit()
		else:
			SceneLoader.change_to_level(level)

func set_label() -> void:
	if lock.is_locked():
		label.text = "Locked!"
	elif level == null:
		label.text = "Home Base"
	else:
		label.text = level.name
