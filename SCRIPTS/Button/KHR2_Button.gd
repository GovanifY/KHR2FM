func _ready():
	connect("pressed", SE, "play", ["system_confirm"])
	connect("focus_enter", SE, "play", ["system_selected"])
