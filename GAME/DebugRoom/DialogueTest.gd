extends Node

# Instance members
onready var Dialogue = get_node("Dialogue")

# Characters
onready var Kiryoku  = get_node("Kiryoku")
onready var Yuugure  = get_node("Yuugure")
onready var Narrator = get_node("Narrator")

# "Private" members
var cursor = 0

######################
### Core functions ###
######################
func _ready():
	# Connecting nodes
	Dialogue.connect("finished", self, "_inc_cursor")

	# Starting first lines
	_fetch_sequence()

func _inc_cursor():
	cursor += 1
	_fetch_sequence()

func _fetch_sequence():
	if cursor == 0:
		Yuugure.set_pos(700)
		Dialogue.speak(Yuugure, 0, 1)
	elif cursor == 1:
		Dialogue.speak(Narrator, 0, 0)
	elif cursor == 2:
		Kiryoku.set_pos(200)
		Dialogue.speak(Kiryoku, 0, 1)
	else:
		Dialogue.silence()
		cursor = 0
		_fetch_sequence()
