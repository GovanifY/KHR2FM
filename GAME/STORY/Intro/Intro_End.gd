extends Node

# Instance members
onready var Sequences = get_node("Master")
var path_dialogue = "res://SCENES/Dialogue/Dialogue.tscn"

######################
### Core functions ###
######################
func _ready():
	# Begin cutscene
	Sequences.play("Kiryoku_down")
	yield(Sequences, "finished")
	
	
	SceneLoader.load_scene(path_dialogue, SceneLoader.BACKGROUND)
	var Dialogue = SceneLoader.show_scene(path_dialogue)
	Dialogue.connect("hide", SceneLoader, "erase_scene", [Dialogue])

	Dialogue.show(true)
	yield(Dialogue.Bubble, "shown")

	#for line in [
	#	[Kiryoku, 20, 22]
	#]:
	#	Dialogue.write(line)
	#	yield(Dialogue, "finished")

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
