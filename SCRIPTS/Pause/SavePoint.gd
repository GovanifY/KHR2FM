extends Panel

# Constants
enum { SAVEPOINT_SAVE, SAVEPOINT_WORLD }

# Instance members
onready var Options  = get_node("Options").get_children()
onready var SaveMenu = get_node("SaveMenu")

######################
### Core functions ###
######################
func _ready():
	connect("draw", self, "_show")

	# Connecting main options
	for i in range(0, Options.size()):
		Options[i].connect("pressed", self, "_pressed", [i])

func _input(event):
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_cancel"):
			if !SaveMenu.is_hidden():
				_dismiss_save_menu()
			# TODO: Add condition for if the confirmation window is visible
			else:
				_dismiss_menu()

func _dismiss_menu():
	set_process_input(false)
	hide()
	KHR2.pause_game(false)

func _dismiss_save_menu():
	if !SaveMenu.anims.is_playing():
		for i in range(0, Options.size()):
			Options[i].set_focus_mode(FOCUS_ALL)
		Options[0].grab_focus()

		SaveMenu.anims.play("Fade Out")

#######################
### Signal routines ###
#######################
func _show():
	KHR2.pause_game(true)
	Options[0].grab_focus()
	set_process_input(true)

func _pressed(button_idx):
	# General rules
	for i in range(0, Options.size()):
		Options[i].set_focus_mode(FOCUS_NONE)

	# Specific rules
	if button_idx == SAVEPOINT_SAVE:
		if SaveMenu.anims.is_playing():
			yield(SaveMenu.anims, "finished")
		SaveMenu.anims.play("Fade In")

	elif button_idx == SAVEPOINT_WORLD:
		pass # TODO: Ask if player wants to access the world map
