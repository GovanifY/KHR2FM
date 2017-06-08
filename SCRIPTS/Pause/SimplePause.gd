extends Node


# Constants
enum PAUSE_CONTROLS { PAUSE_BUTTON_CONTINUE, PAUSE_BUTTON_SKIP }

# Instance members
onready var Pause = {
	"resume" : get_node("Options/Resume"),
	"skip"   : get_node("Options/Skip")
}

######################
### Core functions ###
######################
func _ready():
	KHR2.connect("toggle_pause", self, "_toggled_pause")
	Pause.resume.connect("pressed", self, "_pause_controls", [PAUSE_BUTTON_CONTINUE])
	Pause.skip.connect("pressed", self, "_pause_controls", [PAUSE_BUTTON_SKIP])

	# Finishing
	hide()

#######################
### Signal routines ###
#######################
func _toggled_pause():
	# Showing screen
	set_hidden(!get_tree().is_paused())

	# If there's no next scene directly queued, disable the Skip button
	# FIXME: dynamically show+enable when the scene is ready
	if !SceneLoader.is_loaded():
		Pause.skip.set_disabled(true)
		Pause.skip.hide()

func _pause_controls(button_idx):
	KHR2.pause_game()
	if button_idx == PAUSE_BUTTON_SKIP:
		SceneLoader.show_next_scene(true)
