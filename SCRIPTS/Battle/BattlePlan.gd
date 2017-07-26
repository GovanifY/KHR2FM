extends Node

# Export values
export(bool) var show_bar_values = false
export(AudioStream) var battle_music

# Constants
const PATH_HUD = "res://SCENES/Battle/HUD/HUD.tscn"

# Instance members
onready var HUD = KHR2.get_node("HUD")

######################
### Core functions ###
######################
func _enter_tree():
	SceneLoader.load_scene(PATH_HUD, SceneLoader.BACKGROUND)
	SceneLoader.show_scene(PATH_HUD)

func _exit_tree():
	SceneLoader.erase_scene(HUD)

func _ready():
	# Preparing debug stuff
	get_tree().call_group(0, "LabelValue", "set_hidden", !show_bar_values)

	# Preparing music
	if battle_music != null:
		# If the tracks are different, swap with the new one
		if (Music.get_stream_name() != battle_music.get_name()):
			Music.set_stream(battle_music)
			Music.play()

	# Setting all battlers' Y position (they must stand down before further instructions)
	var middle = int(OS.get_video_mode_size().y) >> 1
	get_tree().call_group(0, "Battler", "set_y", middle)

	start()

###############
### Methods ###
###############
func start():
	get_tree().call_group(0, "Battler", "fight")

func stop():
	get_tree().call_group(0, "Battler", "at_ease")
