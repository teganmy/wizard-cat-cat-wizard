extends Control


@export var label: Label
@export var bar: ProgressBar

var connected_health: Health
var boss_name: String
var tween: Tween

func _ready() -> void:
	hide()
	modulate.a = 0.0
	get_tree().current_scene.boss_spawned.connect(_on_boss_spawned)
	get_tree().current_scene.boss_defeated.connect(deactivate)

func _on_boss_spawned(new_name: String, health: Health) -> void:
	boss_name = new_name
	connected_health = health
	activate()
	

func activate() -> void:
	if connected_health:
		connected_health.changed.connect(_on_health_changed)
		bar.max_value = connected_health.max_health
		bar.value = bar.max_value
	if boss_name:
		label.text = boss_name
	show()
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)

func deactivate() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	hide()

func _on_health_changed(current: int) -> void:
	bar.value = current
