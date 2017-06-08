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
	# Connecting pause-behavior signals
	KHR2.connect("toggle_pause", self, "_toggled_pause")
	SceneLoader.connect("scene_was_loaded", self, "_toggled_button", [PAUSE_BUTTON_SKIP, false])

	# Connecting button signals
	Pause.resume.connect("pressed", self, "_pause_controls", [PAUSE_BUTTON_CONTINUE])
	Pause.skip.connect("pressed", self, "_pause_controls", [PAUSE_BUTTON_SKIP])

	# Finishing
	_toggled_button(PAUSE_BUTTON_SKIP, true)
	hide()

#######################
### Signal routines ###
#######################
func _toggled_button(button_idx, value):
	var button = get_node("Options").get_child(button_idx)
	button.set_disabled(value)

func _toggled_pause():
	set_hidden(!get_tree().is_paused()) # Showing screen

func _pause_controls(button_idx):
	KHR2.pause_game()
	if button_idx == PAUSE_BUTTON_SKIP:
		SceneLoader.show_next_scene(true)
