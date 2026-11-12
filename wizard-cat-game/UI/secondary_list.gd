extends GridContainer


@export var child_script: GDScript

func reload() -> void:
	var secondaries = PlayerState.secondaries
	get_children().map(func(n: Node): n.queue_free())
	for secondary in secondaries:
		var panel = PanelContainer.new()
		panel.set_script(child_script)
		panel.set("def", secondary)
		add_child(panel)
