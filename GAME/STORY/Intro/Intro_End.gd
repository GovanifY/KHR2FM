extends Node

# Instance members
onready var Sequences = get_node("Master")
onready var Dialogue  = get_node("Dialogue")
onready var InfoBar   = get_node("Escape/InfoBar")

# Characters
onready var Kiryoku  = Dialogue.get_node("Kiryoku")

######################
### Core functions ###
######################
func _ready():
	# Prepare BGM
	Music.set_stream(preload("res://ASSETS/BGM/Don't give up.ogg"))
	Music.play()

	# Prepare Dialogue for this particular scene
	Dialogue.set_box(0)

	# Begin cutscene
	Sequences.play("Kiryoku_down")
	yield(Sequences, "finished")

	Kiryoku.speak(20, 21)
	yield(Kiryoku, "finished")

	Sequences.play("Swap_Escape")
	yield(Sequences, "finished")

	Kiryoku.speak(22, 23)
	yield(Kiryoku, "finished")

	Dialogue.hide()
	InfoBar.play()

	# TODO: to black then fade in to battle screen then dialogue appears
