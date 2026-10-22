extends StaticBody2D

@export var lock: Lock
## The level the portal is to, or home base if level is zero
@export var level: int = 1:
	set(new_level):
		level = new_level
		if not lock.is_locked():
			set_label()
@export var label: Label

func _ready() -> void:
	label.text = "Locked!"
	lock.unlocked.connect(set_label)

func _on_interaction_area_interact() -> void:
	if not lock.is_locked():
		if level == 0:
			LevelState.try_exit()
		else:
			SceneLoader.change_to_level(level)

func set_label() -> void:
	if level == 0:
		label.text = "Home Base"
	else:
		label.text = "Level %s" % level
