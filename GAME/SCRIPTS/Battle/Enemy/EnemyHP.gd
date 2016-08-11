# Constants
const SLIDE_DURATION = 1.0
const DELAY_DURATION = 0.0

# Instance members
onready var GreenBar = get_node("GreenBar")
onready var RedBar = get_node("SlideHit/RedBar")
onready var FullBubbles = get_node("FullBubbles")
onready var SlideHit = get_node("SlideHit")

var state = {
	"trans" : Tween.TRANS_LINEAR,
	"eases" : Tween.EASE_IN_OUT,
}

######################
### Core functions ###
######################
func _ready():
	pass

func _set_bubbles(num):
	var rect = FullBubbles.get_region_rect()
	rect.pos.x = -270 + min(15 * num, 270)
	FullBubbles.set_region_rect(rect)

func _set_bar_length(value):
	GreenBar.set_scale(Vector2(value, 1))

###############
### Methods ###
###############
# The less this script knows about the target's HP, the better
func init(curHP):
	update(curHP, 0)
	reset_tween()

# Updates values and Tween's position.
# FIXME: Currently too heavy on division. Find better algorithm
func update(curHP, value):
	curHP += value
	var num_bubbles = (curHP / 100)
	var portion_hp = curHP % 100

	# Readjust in case remainder is 0
	if portion_hp == 0:
		num_bubbles -= 1
		portion_hp = 100

	var pos = float(portion_hp) / 100
	_set_bubbles(num_bubbles)
	_set_bar_length(pos)

	#reset_tween()

func reset_tween():
	SlideHit.reset_all()
	SlideHit.remove_all()

	SlideHit.follow_method(RedBar, "set_scale", Vector2(1, 1), GreenBar, "get_scale", SLIDE_DURATION, state.trans, state.eases, DELAY_DURATION)

	var pos = GreenBar.get_scale().x
	SlideHit.set_repeat(false)
	SlideHit.seek(pos)
	SlideHit.start()
