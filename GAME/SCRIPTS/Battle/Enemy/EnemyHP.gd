# Constants
const SLIDE_DURATION = 0.5
const DELAY_DURATION = 1.0

# Instance members
onready var SlideAnim = get_node("SlideAnim")
onready var Bubbles = get_node("Bubbles")
onready var RedBar = get_node("RedBar")

######################
### Core functions ###
######################
# XXX: Temporary code
func _ready():
	init(330)

# FIXME: Currently uses division 2 times. Find better algorithms
func _set_lifebar(curHP, both = false):
	var num_bubbles = curHP / 100 # 1st division
	var len_lifebar = fmod(curHP, 100)

	if len_lifebar == 0 && num_bubbles > 0:
		len_lifebar = 100
		num_bubbles -= 1

	_set_bubbles(num_bubbles)
	set_value(len_lifebar)

	if len_lifebar >= RedBar.get_value():
		both = true

	if both:
		RedBar.set_value(get_value())

	return both

func _set_bubbles(num):
	Bubbles.set_value(num * Bubbles.get_step())

func reset_anim():
	SlideAnim.reset_all()
	SlideAnim.remove_all()

	SlideAnim.set_repeat(false)
	# FIXME: Temporary bullshit values. Redoing this
	SlideAnim.interpolate_method(RedBar, "set_value", RedBar.get_value(), get_value(), SLIDE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT, DELAY_DURATION)
	SlideAnim.start()

###############
### Methods ###
###############
# The less this script knows about the target's HP, the better
func init(curHP):
	_set_lifebar(curHP, true)

# Compares two values and acts accordingly
func update(newHP):
	var is_set = _set_lifebar(newHP)

	if !is_set:
		reset_anim()
