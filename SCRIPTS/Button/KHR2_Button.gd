extends Button

func _ready():
	connect("pressed", SE, "play", ["system_confirm"])
	connect("focus_enter", SE, "play", ["system_selected"])

func grab_focus():
	disconnect("focus_enter", SE, "play")
	.grab_focus()
	connect("focus_enter", SE, "play", ["system_selected"])
