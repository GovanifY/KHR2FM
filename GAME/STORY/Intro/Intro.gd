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
	AudioRoom.set_stream(preload("res://ASSETS/BGM/Into the Darkness.ogg"))
	AudioRoom.play()

	# Begin cutscene
	Sequences.play("Water")
	yield(Sequences, "finished")

	get_node("Kiryoku_down").play()
	Sequences.play("Kiryoku down")
	yield(Sequences, "finished")

	for line in [
		[Yuugure, 0, 4],
		[Kiryoku, 0, 3],
		[Yuugure, 5, 6],
	]:
		line[0].speak(line[1], line[2])
		yield(line[0], "finished")

	Dialogue.hide()
	Sequences.play("Kiryoku vanish")
	yield(Sequences, "finished")

	# Change music
	AudioRoom.set_stream(preload("res://ASSETS/BGM/The Eye of Darkness.ogg"))
	AudioRoom.play()

	for line in [
		[Kiryoku, 4, 10],
		[Yuugure, 7, 8],
		[Kiryoku, 11, 16],
		[Yuugure, 9, 12],
		[Kiryoku, 17, 19],
	]:
		line[0].speak(line[1], line[2])
		yield(line[0], "finished")

	# Load next scene
	SceneLoader.load_next_scene()
