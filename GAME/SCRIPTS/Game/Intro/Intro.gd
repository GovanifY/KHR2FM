extends Node2D

# Instance members
onready var Sequences = get_node("Sequences")
onready var Dialogue = get_node("Dialogue")
var seq_cursor = 0
var cursor = 0

######################
### Core functions ###
######################
func _ready():
	# Connecting nodes
	Dialogue.connect("no_more_lines", self, "_inc_cursor")
	get_node("Master").connect("finished", self, "_inc_cursor")

	# Setting all lines of dialogue
	Dialogue.set_context("INTRO_FATHERSON")
	Dialogue.collect_lines("", 9)
	Dialogue.collect_lines("Yuugure", 13)
	Dialogue.collect_lines("Kiryoku", 20)

	# Starting first lines
	Dialogue.speak("", 9)

func _inc_cursor():
	_fetch_sequence()
	cursor += 1

func _next_anim():
	if !Sequences.is_active():
		Sequences.set_active(true)
	Sequences.transition_node_set_current("state", seq_cursor)
	seq_cursor += 1

func _fetch_sequence():
	if cursor == 0:
		_next_anim()
		Dialogue.set_side("right")
		Dialogue.speak("Yuugure", 5)
	elif cursor == 1:
		Dialogue.speak("Kiryoku", 4)
	elif cursor == 2:
		Dialogue.speak("Yuugure", 2)
	elif cursor == 3:
		_next_anim()
		Dialogue.speak("Kiryoku", 7)
	elif cursor == 4:
		#TODO: Add music&stuff
		SceneLoader.add_scene("Game/Intro/Battle_Yuugure.tscn")
		SceneLoader.load_new_scene()
