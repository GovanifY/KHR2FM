extends Node2D

# Instance members
var cursor = 0
var Dialogue = null

######################
### Core functions ###
######################
func _ready():
	# Setting dialogue node
	Dialogue = get_node("Dialogue")
	Dialogue.connect("no_more_lines", self, "_set_cursor")

	# Setting all lines of dialogue
	Dialogue.set_context("INTRO_FATHERSON")
	Dialogue.collect_lines("", 9)
	Dialogue.collect_lines("Yuugure", 13)
	Dialogue.collect_lines("Kiryoku", 20)

	# Starting first lines
	Dialogue.speak("", 9)
	pass

func _set_cursor():
	if cursor == 0:
		cursor+=1
		Dialogue.set_side("right")
		Dialogue.speak("Yuugure", 5)
	elif cursor == 1:
		cursor+=1
		Dialogue.speak("Kiryoku", 4)
	elif cursor == 2:
		cursor += 1
		Dialogue.speak("Yuugure", 2)
	elif cursor == 3:
		cursor += 1
		Dialogue.speak("Kiryoku", 7)
	pass
