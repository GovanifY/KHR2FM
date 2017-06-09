extends Control

# Button index
enum OPTION_CONTROLS {
	OPTION_MAIN_NEW, OPTION_MAIN_LOAD, OPTION_MAIN_QUIT
}

# Instance members
onready var AnimsMenu = get_node("MainMenu Animations")
onready var Options   = get_node("Options")
onready var Cursor    = get_node("Options/Cursor")
onready var cursor_inc = Cursor.get_texture().get_size() / 4

######################
### Core functions ###
######################
func _ready():
	# Connecting main options
	for i in range(0, Options.get_child_count()-1):
		var button = Options.get_child(i)
		button.connect("pressed", self, "_pressed_main", [i])
		button.connect("focus_enter", self, "_set_cursor_position", [button])

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
		pass # TODO: show difficulty options
	elif button_idx == OPTION_MAIN_LOAD:
		pass # TODO: show save slots
	elif button_idx == OPTION_MAIN_QUIT:
		AnimsMenu.connect("finished", get_tree(), "quit")
		AnimsMenu.play("Dismiss")

func _pressed_new(button_idx):
	pass # TODO: selected difficulty option

func _pressed_load(button_idx):
	pass # TODO: selected save slot
