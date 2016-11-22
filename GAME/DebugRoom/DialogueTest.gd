extends Node

# Instance members
onready var Dialogue = get_node("Dialogue")

# Characters
onready var Kiryoku  = Dialogue.get_node("Kiryoku")
onready var Kioku    = Dialogue.get_node("Kioku")
onready var Yuugure  = Dialogue.get_node("Yuugure")
onready var Narrator = Dialogue.get_node("Narrator")

######################
### Core functions ###
######################
func _ready():
	Dialogue.speak(Yuugure, 0, 1, true)
	yield(Dialogue, "finished")

	Dialogue.speak(Kiryoku, 0, 1)
	yield(Dialogue, "finished")

	Dialogue.speak(Kioku, 0, 1)
	yield(Dialogue, "finished")

	Dialogue.silence()
