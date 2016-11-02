extends Node

# Instance members
onready var Dialogue = get_node("Dialogue")

# Characters
onready var Kiryoku  = get_node("Kiryoku")
onready var Yuugure  = get_node("Yuugure")
onready var Narrator = get_node("Narrator")

######################
### Core functions ###
######################
func _ready():
	# Starting sequence
	_fetch_sequence()

func _fetch_sequence():
	Yuugure.set_pos(700)
	Dialogue.speak(Yuugure, 0, 1)
	yield(Dialogue, "finished")

	Dialogue.speak(Narrator, 0, 0)
	yield(Dialogue, "finished")

	Kiryoku.set_pos(200)
	Dialogue.speak(Kiryoku, 0, 1)
	yield(Dialogue, "finished")

	Dialogue.silence()
