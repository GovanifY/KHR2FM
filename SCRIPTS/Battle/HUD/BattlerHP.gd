extends TextureProgress

# Constants
const SLIDE_DURATION = 0.5
const DELAY_DURATION = 1.0

# Instance members
onready var SlideAnim = get_node("SlideAnim")
onready var RedBar = get_node("RedBar")

######################
### Core functions ###
######################

###############
### Methods ###
###############
# The less this script knows about the target's HP, the better
func init(curHP):
	set_lifebar(curHP, true)

# Compares two values and acts accordingly
func update(newHP):
	var is_set = set_lifebar(newHP)

	if !is_set:
		reset_anim()

### Control methods
func set_lifebar(curHP, both = false):
	set_value(curHP)

	if curHP >= RedBar.get_value():
		both = true

	if both:
		RedBar.set_value(get_value())

	return both

func reset_anim():
	SlideAnim.reset_all()
	SlideAnim.remove_all()
	SlideAnim.set_repeat(false)

	SlideAnim.interpolate_method(RedBar, "set_value", RedBar.get_value(), get_value(), SLIDE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT, DELAY_DURATION)
	SlideAnim.start()
