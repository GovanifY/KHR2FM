extends Node

func _ready():
	hide()
	KHR2.connect("toggle_pause", self, "_pressed_pause")

#######################
### Signal routines ###
#######################
func _pressed_pause():
	set_hidden(!get_tree().is_paused()) # Showing screen

	if get_tree().is_paused():
		SE.play("system_info")
	else:
		SE.play("system_dismiss")
