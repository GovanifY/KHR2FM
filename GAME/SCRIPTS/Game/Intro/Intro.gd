extends Node2D

# Instance members
var cursor = 0
var Dialogue = null

######################
### Core functions ###
######################
func _ready():
	# Setting dialogue lines
	Dialogue = get_node("Dialogue")
	Dialogue.connect("no_more_lines", self, "_set_cursor")

	# Setting first lines of dialogue
	Dialogue.collect("INTRO_TEXT", 8)
	pass

func _set_cursor():
	if cursor == 0:
		cursor+=1
		Dialogue.set_bubble_type("Speech")
		Dialogue.switch_side()
		Dialogue.collect("YUUGURE_INTRO_TEXT", 4)
	elif cursor == 1:
		cursor+=1
		Dialogue.switch_side()
		Dialogue.collect("KIRYOKU_INTRO_TEXT", 3)
	pass
