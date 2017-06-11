func _ready():
	var se = get_node("SE")
	connect("pressed", se, "play", ["System_04"])
	connect("focus_enter", se, "play", ["System_03"])
