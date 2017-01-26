extends Panel

# Signals
signal shown
signal hidden

# Skin data
const ALL_BOXES = [
	preload("res://SCENES/Dialogue/box0.tres"),
	preload("res://SCENES/Dialogue/box1.tres"),
	preload("res://SCENES/Dialogue/box2.tres")
]
enum ALL_BOX_INDEXES { BOX_CHARACTER, BOX_NARRATOR, BOX2 }

# Instance members
onready var Fade       = get_node("Fade")
onready var Hook       = get_node("Hook")
onready var TextScroll = get_node("TextContainer/TextScroll")
var current_box = -1
var current_signal

######################
### Core functions ###
######################
func _ready():
	# Setting up manually any other necessary signals
	Fade.connect("finished", self, "_fade_animation_finished")

	# Hiding bubble
	hide()

#######################
### Signal routines ###
#######################
func _fade_animation_finished():
	# FIXME: Probably not the way I'll leave at the end
	emit_signal(current_signal)

###############
### Methods ###
###############
func show_box():
	Fade.play("In")
	current_signal = "shown"

func hide_box():
	Fade.play("Out")
	current_signal = "hidden"

func get_box():
	return current_box

func set_box(index):
	current_box = index
	# Switching hook
	if 0 <= index && index < Hook.get_vframes():
		Hook.set_frame(index)
		Hook.show()
	else:
		Hook.hide()

	# Switching bubble
	# FIXME: don't forget to look at this
	if 0 <= index && index < ALL_BOXES.size():
		add_style_override("panel", ALL_BOXES[index])

func set_hook_pos(x):
	var limit_left  = get_margin(MARGIN_LEFT)
	var limit_right = get_margin(MARGIN_RIGHT)

	# Search for a switch
	var flip = x > (int(limit_right) >> 1)
	Hook.set_flip_h(flip)

	if x < limit_left:
		x = limit_left
	elif x > limit_right:
		x = limit_right

	Hook.set_pos(Vector2(x, 0))
	return flip

func set_modulate(mod):
	get_stylebox("panel").set_modulate(mod)
	Hook.set_modulate(mod)
