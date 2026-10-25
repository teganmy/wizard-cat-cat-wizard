extends Label

var tween: Tween
var max_waves: int = 0

func _ready() -> void:
	modulate.a = 0
	var tree = get_tree()
	tree.current_scene.room_changed.connect(_on_room_activated)
	tree.current_scene.wave.connect(_on_room_wave)
	tree.current_scene.room_defeated.connect(_on_room_defeated)

func _on_room_activated() -> void:
	max_waves = get_tree().current_scene.current_room.total_waves

func _on_room_wave(wave: int) -> void:
	display("Wave %s of %s" % [wave, max_waves])

func _on_room_defeated() -> void:
	display("Defeated")

func display(display_text: String) -> void:
	text = display_text
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_delay(3.0)
