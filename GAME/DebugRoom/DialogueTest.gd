extends Node

# Instance members
onready var Dialogue = get_node("Dialogue")
var cursor = 0
var temp = 0

######################
### Core functions ###
######################
func _ready():
	# Connecting nodes
	Dialogue.connect("no_more_lines", self, "_inc_cursor")

	# Starting first lines
	_fetch_sequence()

func _inc_cursor():
	temp = (temp + 100) % Dialogue.Bubble.HOOK_LIMIT_RIGHT
	Dialogue.Bubble.set_hook_pos(temp)
	cursor += 1
	_fetch_sequence()

func _fetch_sequence():
	if cursor == 0:
		# Positioning to Top
		Dialogue.Bubble.set_bubble_pos(2)
		Dialogue.speak("Yuugure", 0, 1)
	elif cursor == 1:
		Dialogue.set_csv("res://ASSETS/LANG/TEXT/Game/End_Demo.csv")
		_inc_cursor()
	elif cursor == 2:
		# Positioning to Middle
		Dialogue.Bubble.set_bubble_pos(1)
		Dialogue.speak("Kiryoku", 0, 1)
	elif cursor == 3:
		# Positioning to Bottom
		Dialogue.Bubble.set_bubble_pos(0)
		Dialogue.speak("Kiryoku", 1, 1)
	else:
		Dialogue.set_csv("res://ASSETS/LANG/TEXT/Game/Intro/Intro.csv")
		Dialogue.Bubble.set_skin(0)
		cursor = 0
		_fetch_sequence()
