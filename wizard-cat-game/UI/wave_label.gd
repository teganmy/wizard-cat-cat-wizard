extends Label

var tween: Tween
var max_waves: int = 0

func _ready() -> void:
	modulate.a = 0
	RoomState.activated.connect(_on_room_activated)
	RoomState.wave.connect(_on_room_wave)
	RoomState.defeated.connect(_on_room_defeated)

func _on_room_activated() -> void:
	max_waves = RoomState.max_waves

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
