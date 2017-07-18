extends Node

# Instance members
onready var Dialogue = get_node("Dialogue")
onready var Sequences = get_node("Master")
onready var Loop = get_node("Loop")

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
	Music.set_stream(preload("res://ASSETS/BGM/Into the Darkness.ogg"))
	Music.play()

	# Begin cutscene
	Sequences.play("BG_Appear")
	yield(Sequences, "finished")
#	Sequences.play("Water")
#	yield(Sequences, "finished")

#	get_node("Kiryoku_down").play()
#	Sequences.play("Kiryoku down")
#	yield(Sequences, "finished")

	for line in [
		[Yuugure, 0, 4],
		[Kiryoku, 0, 3],
		[Yuugure, 5, 6],
	]:
		line[0].speak(line[1], line[2])
		yield(line[0], "finished")
	
	Sequences.play("Hurt")
	yield(Sequences, "finished")
	
	Dialogue.hide()
	
	Sequences.play("Flash")
	yield(Sequences, "finished")
	
	
	
	Loop.play("Hand")
	
	Sequences.play("Hand")
	yield(Sequences, "finished")
	



	for line in [
		[Kiryoku, 4, 10]
	]:
		line[0].speak(line[1], line[2])
		yield(line[0], "finished")
		
	Dialogue.hide()
	
	Sequences.play("Keyblade")
	yield(Sequences, "finished")
	
	for line in [
	[	Yuugure, 7, 8],
		[Kiryoku, 11, 16],
		[Yuugure, 9, 12],
		[Kiryoku, 17, 19],
	]:
		line[0].speak(line[1], line[2])
		yield(line[0], "finished")
	
	# Load next scene
	SceneLoader.load_next_scene()
