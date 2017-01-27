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
	_fetch_sequence()

func _fetch_sequence():
	Sequences.play("Water")
	yield(Sequences, "finished")

	Sequences.play("Kiryoku down")
	yield(Sequences, "finished")

	Dialogue.speak(Yuugure, 0, 1)
	yield(Dialogue, "finished")

	Dialogue.speak(Kiryoku, 0, 4)
	yield(Dialogue, "finished")

	Dialogue.speak(Yuugure, 5, 7)
	yield(Dialogue, "finished")

	Dialogue.silence()
	yield(Dialogue, "finished")

	Sequences.play("Kiryoku vanish")
	yield(Sequences, "finished")

	Dialogue.speak(Kiryoku, 4, 7)
	yield(Dialogue, "finished")

	Dialogue.silence()
	SceneLoader.load_scene("STORY/Intro/Battle_Yuugure.tscn")
