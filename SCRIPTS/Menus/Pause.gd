extends Node

func _ready():
	KHR2.connect("pressed_pause", self, "_pressed_pause")
	KHR2.connect("toggled_pause", self, "_toggled_pause")
	set_pause_mode(PAUSE_MODE_PROCESS)

func _draw():
	SE.play("system_info")

#######################
### Signal routines ###
#######################
func _pressed_pause():
	if !get_tree().is_paused() && is_hidden(): # If dismissing
		SE.play("system_dismiss")

func _toggled_pause():
	set_hidden(!get_tree().is_paused()) # Showing screen
