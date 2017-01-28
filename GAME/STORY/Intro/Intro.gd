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

	Dialogue.speak(Yuugure, 0, 3)
	yield(Dialogue, "finished")

	Dialogue.speak(Kiryoku, 0, 3)
	yield(Dialogue, "finished")

	Dialogue.speak(Yuugure, 4, 6)
	yield(Dialogue, "finished")

	Dialogue.silence()
	yield(Dialogue, "finished")

	Dialogue.silence()
	Sequences.play("Kiryoku vanish")
	yield(Sequences, "finished")

	# Change music
	AudioRoom.load_music(get_node("The Eye of the Darkness"))
	AudioRoom.play()

	Dialogue.speak(Kiryoku, 4, 10)
	yield(Dialogue, "finished")

	Dialogue.speak(Yuugure, 7, 8)
	yield(Dialogue, "finished")

	Dialogue.speak(Kiryoku, 11, 16)
	yield(Dialogue, "finished")

	Dialogue.speak(Yuugure, 9, 12)
	yield(Dialogue, "finished")

	Dialogue.speak(Kiryoku, 17, 19)
	yield(Dialogue, "finished")

	# Load next scene
	SceneLoader.load_scene("STORY/Intro/Battle_Yuugure.tscn")
