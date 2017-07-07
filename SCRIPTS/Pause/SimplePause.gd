extends "Pause.gd"

# Constants
enum PAUSE_CONTROLS { PAUSE_BUTTON_CONTINUE }

# Instance members
onready var Options = get_node("Options")

######################
### Core functions ###
######################
func _ready():
	# Connecting button signals
	for i in range(0, Options.get_child_count()):
		var button = Options.get_child(i)
		button.connect("pressed", self, "_pause_controls", [i])

#######################
### Signal routines ###
#######################
func _toggled_pause():
	._toggled_pause()
	if get_tree().is_paused():
		AudioRoom.set_volume(AudioRoom.VOL_LOW)
		Options.get_child(0).grab_focus()
	else:
		AudioRoom.set_volume(AudioRoom.VOL_NORMAL)

func _pause_controls(button_idx):
	KHR2.pause_game()

###############
### Methods ###
###############
func set_availability(button_idx, value):
	var button = Options.get_child(button_idx)
	button.set_disabled(value)
