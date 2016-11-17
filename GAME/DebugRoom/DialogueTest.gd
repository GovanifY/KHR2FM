extends Node

# Instance members
onready var Dialogue = get_node("Dialogue")

# Characters
onready var Kiryoku  = get_node("Kiryoku")
onready var Yuugure  = get_node("Yuugure")

######################
### Core functions ###
######################
func _ready():
	# Starting sequence
	_fetch_sequence()

func _fetch_sequence():
	Yuugure.set_pos(Vector2(700, 0))
	Dialogue.speak(Yuugure, 0, 1)
	yield(Dialogue, "finished")

	Kiryoku.set_pos(Vector2(200, 0))
	Dialogue.speak(Kiryoku, 0, 1)
	yield(Dialogue, "finished")

	Dialogue.silence()
