extends Node

# Instance members
onready var Dialogue = get_node("Dialogue")

# Characters
onready var Kiryoku  = Dialogue.get_node("Kiryoku")
onready var Yuugure  = Dialogue.get_node("Yuugure")
onready var Narrator = Dialogue.get_node("Narrator")

######################
### Core functions ###
######################
func _ready():
	Yuugure.set_pos(Vector2(700, 0))
	Dialogue.speak(Yuugure, 0, 1)
	yield(Dialogue, "finished")

	Kiryoku.set_pos(Vector2(200, 0))
	Dialogue.speak(Kiryoku, 0, 1)
	yield(Dialogue, "finished")

	Dialogue.silence()
