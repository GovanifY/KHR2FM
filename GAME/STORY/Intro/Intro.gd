extends Node

# Instance members
onready var Dialogue = get_node("Dialogue")
onready var Sequences = get_node("Master")

# Characters
onready var Kiryoku  = get_node("Dialogue/Kiryoku")
onready var Yuugure  = get_node("Dialogue/Yuugure")

######################
### Core functions ###
######################
func _ready():
	# Begin cutscene
	_fetch_sequence()

func _fetch_sequence():
	# Starting music
	AudioRoom.load_music(get_node("Into the Darkness"))
	AudioRoom.play()

	Sequences.play("Water")
	yield(Sequences, "finished")

	Sequences.play("Kiryoku down")
	yield(Sequences, "finished")

	#Yuugure.set_pos(Vector2(700, 0))
	Dialogue.speak(Yuugure, 0, 1)
	yield(Dialogue, "finished")

	#Kiryoku.set_pos(Vector2(200, 0))
	Dialogue.speak(Kiryoku, 0, 4)
	yield(Dialogue, "finished")

	Dialogue.speak(Yuugure, 5, 7)
	yield(Dialogue, "finished")

	# TODO: dismiss Dialogue's mugshots

	Sequences.play("Kiryoku vanish")
	yield(Sequences, "finished")

	Dialogue.speak(Kiryoku, 4, 7)
	yield(Dialogue, "finished")

	Dialogue.silence()
	SceneLoader.load_scene("STORY/Intro/Battle_Yuugure.tscn")
