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

	# Preparing miscellaneous nodes
	get_node("Big").set_text("BIG_00")

	# Starting music
	Music.set_stream(preload("res://ASSETS/BGM/Realm of darkness.ogg"))
	Music.play()

	# Begin cutscene
	Sequences.play("BG_Appear")
	yield(Sequences, "finished")

	for line in [
		[Yuugure, 0, 4],
		[Kiryoku, 0, 3],
		[Yuugure, 5, 6],
	]:
		line[0].speak(line[1], line[2])
		yield(line[0], "finished")

	Sequences.play("Hurt")
	yield(Sequences, "finished")

	Dialogue.close()

	Sequences.play("Flash")
	yield(Sequences, "finished")

	Sequences.play("Hand")
	yield(Sequences, "finished")

	Kiryoku.speak(4, 10)
	yield(Kiryoku, "finished")

	Dialogue.close()

	# Switching music
	Music.fade_out(1)
	yield(Music, "end_fade")
	Music.set_stream(preload("res://ASSETS/BGM/Blue.ogg"))
	Music.play()

	Sequences.play("Keyblade")
	yield(Sequences, "finished")

	for line in [
		[Yuugure, 7, 8],
		[Kiryoku, 11, 16],
		[Yuugure, 9, 12],
		[Kiryoku, 17, 19],
	]:
		line[0].speak(line[1], line[2])
		yield(line[0], "finished")

	# Load next scene
	SceneLoader.transition("Battle")
	SceneLoader.load_next_scene()
