extends StaticBody2D

## The level the portal is to, or home base if empty
@export var level: LevelDef:
	set(new_level):
		level = new_level
		set_label()
@export var label: Label
@export_group("Hints")
@export var locked_hint: String = ""
@export var unlocked_hint: String = "E to interact"
@export_group("Wiring")
@export var lock: Lock
@export var interaction_area: InteractionArea

func _ready() -> void:
	set_label()
	lock.unlocked.connect(set_label)
	lock.locked.connect(set_label)

func _on_interaction_area_interact() -> void:
	if not lock.is_locked():
		get_tree().current_scene.complete()
		if level == null:
			SceneLoader.change_to_home(true)
		else:
			SceneLoader.change_to_level(level)

func set_label() -> void:
	if lock.is_locked():
		label.text = "Locked!"
		interaction_area.hint = locked_hint
	elif level == null:
		label.text = "Home Base"
		interaction_area.hint = unlocked_hint
	else:
		label.text = level.name
		interaction_area.hint = unlocked_hint
