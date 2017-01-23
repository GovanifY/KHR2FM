extends TextureProgress

# Exported values
export(float, 0, 5, 0.1) var SLIDE_DURATION = 0.5
export(float, 0, 5, 0.1) var DELAY_DURATION = 1.0

# Instance members
# A DynamicBar requires a Tween node with this name
onready var SlideAnim = get_node("SlideAnim")
var max_value = 0

###############
### Methods ###
###############
func set_max_value(value):
	max_value = value
	set_value(value)

func update(value):
	set_value(value)

######################
### Core functions ###
######################
func play_anim(target):
	SlideAnim.interpolate_method(target, "set_value", target.get_value(), get_value(), SLIDE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT, DELAY_DURATION)
	SlideAnim.start()

func reset_anim():
	SlideAnim.reset_all()
	SlideAnim.remove_all()
	SlideAnim.set_repeat(false)
