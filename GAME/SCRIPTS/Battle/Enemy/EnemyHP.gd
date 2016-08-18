extends "res://GAME/SCRIPTS/Battle/HUD/BattlerHP.gd"

# Instance members
onready var Bubbles = get_node("Bubbles")

######################
### Core functions ###
######################
# FIXME: This function uses division 2 times. Find better algorithm
func set_lifebar(curHP, both = false):
	var len_lifebar = fmod(curHP, 100)
	var num_bubbles = curHP / 100

	if len_lifebar == 0 && num_bubbles > 0:
		len_lifebar = 100
		num_bubbles -= 1

	Bubbles.set_value(num_bubbles * Bubbles.get_step())
	return .set_lifebar(len_lifebar, both)
