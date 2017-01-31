extends Node

# Instance members
onready var Dialogue = get_node("Dialogue")

# Characters
onready var Kiryoku  = Dialogue.get_node("Kiryoku")
onready var Kioku    = Dialogue.get_node("Kioku")
onready var Yuugure  = Dialogue.get_node("Yuugure")

######################
### Core functions ###
######################
func _ready():
	# Getting Dialogue box and Characters ready
	Kiryoku.set_side(false)
	Kioku.set_side(false)
	Yuugure.set_side(true)

	# Commence dialogue
	Yuugure.speak(0, 1)
	yield(Yuugure, "finished")

	Yuugure.speak(2, 3)
	yield(Yuugure, "finished")

	# Recalibrate for narrator
	Dialogue.set_box(2)
	Dialogue.write("I can write anything here!!")
	yield(Dialogue, "finished")

	Dialogue.set_box(1)
	Kiryoku.speak(0, 1)
	yield(Kiryoku, "finished")

	Kiryoku.dismiss()
	yield(Kiryoku, "finished")

	Kioku.speak(0, 1)
	yield(Kioku, "finished")

	Kioku.speak(1, 2)
	yield(Kioku, "finished")

	Dialogue.silence()
