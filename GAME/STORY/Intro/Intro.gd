extends Node2D

# Instance members
onready var Dialogue = get_node("Dialogue")
onready var Sequences = get_node("Master")
var cursor = 0

######################
### Core functions ###
######################
func _ready():
	# Connecting nodes
	Dialogue.connect("finished", self, "_inc_cursor")
	# Setting all lines of dialogue
	Dialogue.set_context("INTRO_FATHERSON")
	Dialogue.collect_lines("Yuugure", 13)
	Dialogue.collect_lines("Kiryoku", 20)

	# Starting first lines
	AudioRoom.load_music(get_node("Into the Darkness"))
	AudioRoom.play()
	_fetch_sequence()

func _inc_cursor():
	cursor += 1
	_fetch_sequence()

func _play_anim(name):
	Sequences.play(name)
	yield(Sequences, "finished")
	_inc_cursor()

func _fetch_sequence():
	if cursor == 0:
		_play_anim("Water")
	elif cursor == 1:
		_play_anim("Kiryoku down")
	elif cursor == 2:
		Dialogue.set_side("right")
		Dialogue.speak("Yuugure", 5)
	elif cursor == 3:
		Dialogue.speak("Kiryoku", 4)
	elif cursor == 4:
		Dialogue.speak("Yuugure", 2)
	elif cursor == 5:
		# TODO: dismiss Dialogue's mugshots
		_play_anim("Kiryoku vanish")
	elif cursor == 6:
		Dialogue.speak("Kiryoku", 7)
	elif cursor == 7:
		#TODO: Add music&stuff
		SceneLoader.add_scene("Intro/Battle_Yuugure.tscn")
		SceneLoader.load_new_scene()
