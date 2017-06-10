extends Panel

# Signals
signal dismiss
signal finished

# Instance members
onready var anims = get_node("Anims")
onready var Slots = get_node("Slots")

######################
### Core functions ###
######################
func _ready():
	# TODO: Auto-generate save slots, according to info from SaveManager

	connect("draw", self, "set_process_input", [true])
	connect("hide", self, "set_process_input", [false])

func _input(event):
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_cancel"):
			emit_signal("dismiss")

#######################
### Signal routines ###
#######################
func _pressed_load(button_idx):
	# TODO: Load a game
	emit_signal("finished")
