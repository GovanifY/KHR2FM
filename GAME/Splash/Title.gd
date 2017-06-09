extends Control

# Button index
enum OPTION_CONTROLS {
	OPTION_MAIN_NEW, OPTION_MAIN_LOAD, OPTION_MAIN_QUIT,
	OPTION_NEW_STANDARD, OPTION_NEW_HARD,
}

# Instance members
onready var Options = {
	"start" : get_node("Options/New Game"),
	"load"  : get_node("Options/Load Game"),
	"quit"  : get_node("Options/Quit Game"),
}

######################
### Core functions ###
######################
func _ready():
	# Connecting main options
	Options.start.connect("button_down", self, "_pressed_main", [OPTION_MAIN_NEW])
	Options.load.connect("button_down", self, "_pressed_main", [OPTION_MAIN_LOAD])
	Options.quit.connect("button_down", self, "_pressed_main", [OPTION_MAIN_QUIT])

	# Introducing Title
	set_process(true)

func _process(delta):
	pass

#######################
### Signal routines ###
#######################
func _pressed_main(button_idx):
	if button_idx == OPTION_MAIN_NEW:
		pass # TODO: show difficulty options
	elif button_idx == OPTION_MAIN_LOAD:
		pass # TODO: show save slots
	elif button_idx == OPTION_MAIN_QUIT:
		get_tree().quit()

func _pressed_new(button_idx):
	pass # TODO: selected difficulty option

func _pressed_load(button_idx):
	pass # TODO: selected save slot
