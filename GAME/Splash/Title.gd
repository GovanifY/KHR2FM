extends Control

# Button index
enum OPTION_CONTROLS {
	OPTION_MAIN_NEW, OPTION_MAIN_LOAD, OPTION_MAIN_QUIT
}

# Instance members
onready var AnimsMenu = get_node("MainMenu Animations")

######################
### Core functions ###
######################
func _ready():
	# Connecting main options
	var options = get_node("Options")
	for i in range(0, options.get_child_count()-1):
		var button = options.get_child(i)
		button.connect("pressed", self, "_pressed_main", [i])

	# Presenting Title
	AnimsMenu.play("Background")

#######################
### Signal routines ###
#######################
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
