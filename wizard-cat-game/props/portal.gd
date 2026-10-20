extends StaticBody2D

enum DESTINATION {HOME, LEVEL}

@export var lock: Lock
@export var destination: DESTINATION
## The level the portal is to, if destination is set to level
@export var level: int = 1

func _on_interaction_area_interact() -> void:
	if not lock.is_locked():
		match destination:
			DESTINATION.HOME:
				LevelState.try_exit()
			DESTINATION.LEVEL:
				SceneLoader.change_to_level(level)
