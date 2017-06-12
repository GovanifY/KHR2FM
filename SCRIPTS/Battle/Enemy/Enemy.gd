extends "res://SCRIPTS/Battle/Battler.gd"


######################
### Core functions ###
######################
func _ready():
	add_to_group(.get_type())
	add_to_group(get_type())

###############
### Methods ###
###############
### Overloading functions
func get_type():
	return "Enemy"

func is_type(type):
	return type == get_type()

### Handling animations
func random_voice(snd_arr):
	var voice = get_node("Voice")
	if typeof(snd_arr) == TYPE_STRING_ARRAY && voice != null:
		var rng = randi() % snd_arr.size()
		voice.play(snd_arr[rng])