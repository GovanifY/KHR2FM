extends Panel


# Button index
enum { OPTION_DIFFICULTY_NORMAL, OPTION_DIFFICULTY_CRITICAL }

onready var Options = get_node("Window/Options")

######################
### Core functions ###
######################
func _ready():
	# Connecting main options
	for i in range(0, Options.get_child_count()):
		var button = Options.get_child(i)
		button.connect("pressed", self, "_pressed_new", [i])

#######################
### Signal routines ###
#######################
func _pressed_new(button_idx):
	if button_idx == OPTION_DIFFICULTY_NORMAL:
		pass # TODO: Set up new game in Normal
	elif button_idx == OPTION_DIFFICULTY_CRITICAL:
		pass # TODO: Set up new game in Critical, ask for EXP_Zero

	# TODO: In any case, prepare Aqua intro at the end of the flashy animation
	#SceneLoader.load_scene("res://GAME/STORY/Intro/Aqua.tscn")
