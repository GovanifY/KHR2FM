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
	# Getting Dialogue box and Characters ready
	Dialogue.set_box(0)
	Kiryoku.set_side(false)
	Kioku.set_side(false)
	Yuugure.set_side(true)

	# Commence dialogue
	Dialogue.speak(Yuugure, 0, 1)
	yield(Dialogue, "finished")

	Dialogue.speak(Yuugure, 2, 3)
	yield(Dialogue, "finished")

	# Recalibrate for narrator
	Dialogue.set_box(2)
	Dialogue.speak(Narrator, 0, 1)
	yield(Dialogue, "finished")

	Dialogue.set_box(1)
	Dialogue.speak(Kiryoku, 0, 1)
	yield(Dialogue, "finished")

	Kiryoku.dismiss()
	yield(Dialogue, "finished")

	Dialogue.speak(Kioku, 0, 1)
	yield(Dialogue, "finished")

	Dialogue.speak(Kioku, 1, 2)
	yield(Dialogue, "finished")

	Dialogue.silence()
