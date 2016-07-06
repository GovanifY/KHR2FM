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

	# Setting first lines of dialogue
	Dialogue.set_bubble_type("Narrator")
	Dialogue.collect_lines("INTRO_TEXT", 8)
	Dialogue.open_dialogue()
	pass

func _set_cursor():
	if cursor == 0:
		cursor+=1
		Dialogue.set_bubble_type("Speech")
		Dialogue.collect_lines("YUUGURE_INTRO_TEXT", 4)
		Dialogue.switch_side()
		Dialogue.open_dialogue()
	elif cursor == 1:
		cursor+=1
		Dialogue.collect_lines("KIRYOKU_INTRO_TEXT", 3)
		Dialogue.switch_side()
		Dialogue.open_dialogue()
	pass
