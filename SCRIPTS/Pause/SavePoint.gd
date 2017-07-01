extends Panel

# Constants
enum { SAVEPOINT_SAVE, SAVEPOINT_WORLD }

# Instance members
onready var Options  = get_node("Options").get_children()
onready var SaveMenu = get_node("SaveMenu")

var cursor_idx = 0

######################
### Core functions ###
######################
func _ready():
	connect("draw", self, "_show")

	# Connecting main options
	for i in range(0, Options.size()):
		Options[i].connect("pressed", self, "_pressed", [i])
		Options[i].connect("cancel", self, "_dismissed_menu")

func _dismissed_menu():
	for i in range(0, Options.size()):
		Options[i].set_focus_mode(FOCUS_ALL)
	Options[cursor_idx].grab_focus()

#######################
### Signal routines ###
#######################
func _show():
	KHR2.pause_game(true)
	Options[0].grab_focus()

func _hide():
	KHR2.pause_game(false)

func _pressed(button_idx):
	cursor_idx = button_idx

	# General rules
	for i in range(0, Options.size()):
		Options[i].set_focus_mode(FOCUS_NONE)

	# Specific rules
	if button_idx == SAVEPOINT_SAVE && SaveMenu.is_hidden():
		SaveMenu.anims.play("Fade In")

	elif button_idx == SAVEPOINT_WORLD:
		pass # TODO: Ask if player wants to access the world map
