class_name BossRoom
extends Room

@export var boss_def: BossDef
@export var boss_scene: PackedScene
@export var boss_spawner: Marker2D 

var boss: CharacterBody2D

func _change_state(new_state: STATE) -> void:
	state = new_state
	match new_state:
		STATE.ACTIVE:
			_on_activated()
		STATE.DEFEATED:
			_on_defeated()

func _on_activated() -> void:
	boss = boss_scene.instantiate()
	boss.def = boss_def
	add_child.call_deferred(boss)
	boss.defeated.connect(defeat)
	get_tree().current_scene.spawn_boss.call_deferred(boss)

func _on_defeated() -> void:
	pass
