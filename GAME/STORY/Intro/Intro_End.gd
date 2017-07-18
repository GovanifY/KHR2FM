extends Node

# Instance members
onready var Sequences = get_node("Master")
onready var Dialogue = get_node("Dialogue")
onready var Kiryoku  = Dialogue.get_node("Kiryoku")
onready var InfoBar = get_node("Escape/InfoBar")


######################
### Core functions ###
######################
func _ready():
	# Begin cutscene
	Sequences.play("Kiryoku_down")
	yield(Sequences, "finished")

	Dialogue.set_box(2)
	Dialogue.show(true)
	yield(Dialogue.Bubble, "shown")

	for line in [
		[Kiryoku, 20, 21]
	]:
		line[0].speak(line[1], line[2])
		yield(Dialogue, "finished")

	Sequences.play("Swap_Escape")
	yield(Sequences, "finished")
	
	#I made a dummy animation to be able to hide dialogue before showing it again
	#Dialogue.show()
	
	#Dialogue.show()
	for line in [
		[Kiryoku, 22, 23]
	]:
		line[0].speak(line[1], line[2])
		yield(Dialogue, "finished")
	
	Dialogue.hide()

	InfoBar.play()
	
	
	#ANIM: to black then fade in to battle screen then dialogue appears
	#Dialogue.hide()

#	Sequences.play("Water")
#	yield(Sequences, "finished")

#	get_node("Kiryoku_down").play()
#	Sequences.play("Kiryoku down")
#	yield(Sequences, "finished")

	#for line in [
	#	[Yuugure, 0, 4],
	#	[Kiryoku, 0, 3],
	#	[Yuugure, 5, 6],
	#]:
	#	line[0].speak(line[1], line[2])
	#	yield(line[0], "finished")
	
	# Load next scene
	#SceneLoader.transition("Battle")
	#SceneLoader.load_next_scene()
