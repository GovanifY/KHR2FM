extends "SimplePause.gd"

# Constants
enum PAUSE_CONTROLS { PAUSE_BUTTON_CONTINUE, PAUSE_BUTTON_SKIP }

######################
### Core functions ###
######################
func _ready():
	set_availability(PAUSE_BUTTON_SKIP, true)
	SceneLoader.connect("has_queued", self, "set_availability", [PAUSE_BUTTON_SKIP, false])

#######################
### Signal routines ###
#######################
func _pause_controls(button_idx):
	KHR2.pause_game()
	if button_idx == PAUSE_BUTTON_SKIP:
		if SceneLoader.has_loaded():
			SceneLoader.show_next_scene(true)
		else:
			SceneLoader.load_next_scene()
