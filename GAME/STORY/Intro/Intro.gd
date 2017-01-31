extends Node

# Instance members
onready var Dialogue = get_node("Dialogue")
onready var Sequences = get_node("Master")

# Characters
onready var Kiryoku  = Dialogue.get_node("Kiryoku")
onready var Yuugure  = Dialogue.get_node("Yuugure")

######################
### Core functions ###
######################
func _ready():
	# Setting characters
	Kiryoku.set_side(false)
	Yuugure.set_side(true)

	# Starting music
	AudioRoom.load_music(get_node("Into the Darkness"))
	AudioRoom.play()

	# Begin cutscene
	Sequences.play("Water")
	yield(Sequences, "finished")

	get_node("Kiryoku_down").play()
	Sequences.play("Kiryoku down")
	yield(Sequences, "finished")

	Yuugure.speak(0, 4)
	yield(Yuugure, "finished")

	Kiryoku.speak(0, 3)
	yield(Kiryoku, "finished")

	Yuugure.speak(5, 6)
	yield(Yuugure, "finished")

	Dialogue.clear()
	Sequences.play("Kiryoku vanish")
	yield(Sequences, "finished")
	Dialogue.dismiss()

	# Change music
	AudioRoom.load_music(get_node("The Eye of the Darkness"))
	AudioRoom.play()

	Kiryoku.speak(4, 10)
	yield(Kiryoku, "finished")

	Yuugure.speak(7, 8)
	yield(Yuugure, "finished")

	Kiryoku.speak(11, 16)
	yield(Kiryoku, "finished")

	Yuugure.speak(9, 12)
	yield(Yuugure, "finished")

	Kiryoku.speak(17, 19)
	yield(Kiryoku, "finished")

	# Load next scene
	SceneLoader.load_scene("STORY/Intro/Battle_Yuugure.tscn")
