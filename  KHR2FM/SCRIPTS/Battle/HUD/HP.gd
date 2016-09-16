extends "res://SCRIPTS/Battle/HUD/DynamicBar.gd"

# Constants
const SLIDE_DURATION = 0.5
const DELAY_DURATION = 1.0

# Instance members
onready var RedBar = get_node("RedBar")

###############
### Methods ###
###############
func init(current_val):
	set_lifebar(current_val, true)

func update(new_val):
	var is_set = set_lifebar(new_val)

	if !is_set:
		reset_anim()

######################
### Core functions ###
######################
### Control methods
func set_lifebar(curHP, both = false):
	set_value(curHP)

	if curHP >= RedBar.get_value():
		both = true

	if both:
		RedBar.set_value(get_value())

	return both

func reset_anim():
	.reset_anim()

	SlideAnim.interpolate_method(RedBar, "set_value", RedBar.get_value(), get_value(), SLIDE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT, DELAY_DURATION)
	SlideAnim.start()
