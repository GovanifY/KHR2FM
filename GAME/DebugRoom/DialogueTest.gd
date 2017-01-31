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

	# 1. Test character displaying + any number of lines given
	Yuugure.speak(0, 1)
	yield(Yuugure, "finished")

	Kiryoku.speak(0)
	yield(Kiryoku, "finished")

	# 2. Test dialogue with characters already on screen
	Yuugure.speak(2)
	yield(Yuugure, "finished")

	Kiryoku.speak(1)
	yield(Kiryoku, "finished")

	Yuugure.speak(2)
	yield(Yuugure, "finished")

	Kiryoku.speak(1)
	yield(Kiryoku, "finished")

	# 3. Test the same character speaking more than once in a row
	Yuugure.speak(3)
	yield(Yuugure, "finished")

	Yuugure.speak(3)
	yield(Yuugure, "finished")

	Yuugure.speak(3)
	yield(Yuugure, "finished")

	# 4. Test negative numbers
	Kiryoku.speak(4, 3)
	yield(Kiryoku, "finished")

	Kiryoku.speak(-1)
	yield(Kiryoku, "finished")

	# 5. Test other boxes
	Dialogue.set_box(2)
	Dialogue.write("I can write anything here!!")
	yield(Dialogue, "finished")

	# 6. Test dismissal
	Kiryoku.dismiss()
	yield(Kiryoku, "finished")

	Dialogue.set_box(1)
	Kioku.speak(0, 1)
	yield(Kioku, "finished")

	Kioku.speak(1, 2)
	yield(Kioku, "finished")

	Dialogue.clear()
