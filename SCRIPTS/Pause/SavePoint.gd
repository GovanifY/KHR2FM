extends "Pause.gd"

# Constants
enum { SAVEPOINT_SAVE, SAVEPOINT_WORLD }

# Instance members
onready var Options = get_node("Options").get_children()
onready var Choices = get_node("Confirm/BinaryChoice")
onready var Menu    = [
	get_node("SaveMenu"),
	get_node("Confirm"),
]

var cursor_idx = 0

######################
### Core functions ###
######################
func _ready():
	connect("hide", self, "_hide")

	# Connecting main options
	for i in range(0, Options.size()):
		Options[i].connect("pressed", self, "_pressed", [i])
		Options[i].connect("cancel", self, "hide")

		Menu[i].connect("hide", self, "_dismissed_menu")
		Menu[i].hide()

	# Setting up Choices
	Choices.connect("draw", Choices.no, "grab_focus")
	Choices.connect("pressed", self, "confirm_choice") # FIXME: load World Map

#######################
### Signal routines ###
#######################
func _draw():
	KHR2.pause_game(true)
	Options[0].grab_focus()

func _hide():
	KHR2.pause_game(false)

func _pressed(button_idx):
	cursor_idx = button_idx

	# General rules
	for i in range(0, Options.size()):
		Options[i].set_focus_mode(Options[i].FOCUS_NONE)

	if Menu[button_idx].is_hidden():
		Menu[button_idx].anims.play("Fade In")

func _dismissed_menu():
	for i in range(0, Options.size()):
		Options[i].set_focus_mode(Options[i].FOCUS_ALL)
	Options[cursor_idx].grab_focus()

###############
### Methods ###
###############
func confirm_choice(yes):
	if not yes:
		Menu[cursor_idx].anims.play("Fade Out")
		return false

	if cursor_idx == SAVEPOINT_WORLD:
		# TODO: Load World Map
		Menu[cursor_idx].anims.play("Fade Out")
