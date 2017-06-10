extends Control

# Button index
enum OPTION_CONTROLS { OPTION_MAIN_NEW, OPTION_MAIN_LOAD, OPTION_MAIN_QUIT }

# Main Menu instance members
onready var AnimsMenu = get_node("Anims_MM")
onready var Options   = get_node("Options")
onready var Cursor    = get_node("Options/Cursor")
onready var cursor_inc = Cursor.get_texture().get_size() / 4

# New game instance members
onready var BG_New   = get_node("BG_New")
onready var AnimsNew = get_node("BG_New/Anims_New")

######################
### Core functions ###
######################
func _ready():
	# Connecting main options
	for i in range(0, Options.get_child_count()-1):
		var button = Options.get_child(i)
		button.connect("pressed", self, "_pressed_main", [i])
		button.connect("focus_enter", self, "_set_cursor_position", [button])

	# Connecting New Game options
	BG_New.connect("dismiss", AnimsNew, "play", ["Fade Out"])
	BG_New.connect("finished", self, "_start_new")

	# Presenting Title
	AnimsMenu.play("Background")

#######################
### Signal routines ###
#######################
func _set_cursor_position(button):
	var pos = button.get_pos() + cursor_inc
	Cursor.set_pos(pos)

func _pressed_main(button_idx):
	if button_idx == OPTION_MAIN_NEW:
		AnimsNew.play("Fade In")
	elif button_idx == OPTION_MAIN_LOAD:
		pass # TODO: show save slots
	elif button_idx == OPTION_MAIN_QUIT:
		AnimsMenu.connect("finished", get_tree(), "quit")
		AnimsMenu.play("Dismiss")

func _start_new():
	# Load Aqua intro at the end of the flashy animation
	AnimsMenu.connect("finished", SceneLoader, "load_scene", ["res://GAME/STORY/Intro/Aqua.tscn"])
	AnimsMenu.play("New Game")

func _start_load():
	pass # TODO: selected save slot
