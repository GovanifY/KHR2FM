extends ProgressBar

################################################################################
#	DynamicBar
# A representation and partial dataholder for stuff like Health bars
################################################################################


# Exported values
export(float, 0, 5, 0.1) var SLIDE_DURATION = 0.5
export(float, 0, 5, 0.1) var DELAY_DURATION = 1.0

# Instance members
onready var SlideAnim = Tween.new() # A Tween that serves for the progress sliding animation

# "Private" members
var limit_value = 1
var stats

######################
### Core functions ###
######################
func _ready():
	SlideAnim.set_name("SlideAnim")
	SlideAnim.set_repeat(false)
	add_child(SlideAnim)

func _play_anim(target):
	SlideAnim.interpolate_method(target, "set_value", target.get_value(), get_value(), SLIDE_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT, DELAY_DURATION)
	SlideAnim.start()

###############
### Methods ###
###############
### Overloading functions
func get_type():
	return "DynamicBar"

func is_type(type):
	return type == get_type()

### Dynamic bar virtual methods
func update(value):
	set_value(min(value, limit_value))

func set_limit_value(value):
	limit_value = value
