# Constants
const SLIDE_DURATION = 0.5
const DELAY_DURATION = 1.0
const REGION_MAX_BUBBLES = 270
const SIZE_BUBBLE = 15

# Instance members
onready var Slide = get_node("Slide")
onready var GreenBar = get_node("Slide/GreenBar")
onready var RedBar = get_node("Slide/RedBar")
onready var FullBubbles = get_node("FullBubbles")

# Specific data
var NumBubbles

######################
### Core functions ###
######################
# FIXME: Currently uses division 2 times. Find better algorithms
func _set_lifebar(curHP, both = false):
	NumBubbles = curHP / 100 # 1st division
	var len_lifebar = fmod(curHP, 100)

	if len_lifebar == 0 && NumBubbles > 0:
		len_lifebar = 100
		NumBubbles -= 1

	_set_bubbles(NumBubbles)
	_reset_tween()

	var pos_cur = float(len_lifebar) / 100
	if pos_cur >= RedBar.get_scale().x:
		both = true

	var scale = Vector2(pos_cur, 1) # 2nd division
	GreenBar.set_scale(scale)
	if both:
		RedBar.set_scale(scale)

	return both

func _set_bubbles(num):
	var rect = FullBubbles.get_region_rect()
	rect.pos.x = -REGION_MAX_BUBBLES + min(SIZE_BUBBLE * num, REGION_MAX_BUBBLES)
	FullBubbles.set_region_rect(rect)

func _reset_tween():
	Slide.reset_all()
	Slide.remove_all()

	Slide.set_repeat(false)

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
		var starting_point = RedBar.get_scale()
		Slide.follow_method(RedBar, "set_scale", starting_point, GreenBar, "get_scale", SLIDE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, DELAY_DURATION)
		Slide.start()
