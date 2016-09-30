extends Node

# Instance members
onready var Dialogue = get_node("Dialogue")
var cursor = 0

######################
### Core functions ###
######################
func _ready():
	# Connecting nodes
	Dialogue.connect("no_more_lines", self, "_inc_cursor")
	Dialogue.Bubble.set_bubble_skin(0)

	# Starting first lines
	_fetch_sequence()

func _inc_cursor():
	cursor += 1
	_fetch_sequence()

func _fetch_sequence():
	if cursor == 0:
		Dialogue.speak("Yuugure", 1)
	elif cursor == 1:
		Dialogue.speak("Kiryoku", 1)
	elif cursor == 2:
		Dialogue.silence()
