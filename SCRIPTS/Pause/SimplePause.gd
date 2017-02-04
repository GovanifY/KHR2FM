extends Node


# Constants
enum { PAUSE_BUTTON_CONTINUE, PAUSE_BUTTON_SKIP }

######################
### Core functions ###
######################
func _ready():
	var skip_button = get_node("Options/Skip")
	get_node("Options/Continue").connect("pressed", self, "_pause_controls", [PAUSE_BUTTON_CONTINUE])
	skip_button.connect("pressed", self, "_pause_controls", [PAUSE_BUTTON_SKIP])

	# If there's no next scene directly queued, disable the Skip button
	if !SceneLoader.is_loaded():
		skip_button.set_disabled(true)
		skip_button.hide()

#######################
### Signal routines ###
#######################
func _pause_controls(button_idx):
	if button_idx == PAUSE_BUTTON_CONTINUE:
		KHR2.pause_game()
	elif button_idx == PAUSE_BUTTON_SKIP:
		KHR2.pause_game()
		SceneLoader.show_next_scene(true)
