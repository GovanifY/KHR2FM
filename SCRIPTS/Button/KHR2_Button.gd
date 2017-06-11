func _ready():
	connect("pressed", SE, "play", ["System_04"])
	connect("focus_enter", SE, "play", ["System_03"])
