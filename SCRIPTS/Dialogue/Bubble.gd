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
enum ALL_BOX_INDEXES { BOX_CHARACTER, BOX_NARRATOR1, BOX_NARRATOR2 }

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

	# Preparing bubble
	set_box(BOX_CHARACTER)
	hide()

#######################
### Signal routines ###
#######################
func _fade_animation_finished():
	emit_signal(current_signal)

###############
### Methods ###
###############
func show_box():
	if is_hidden():
		Fade.play("In")
		current_signal = "shown"

func hide_box():
	if is_visible():
		Fade.play("Out")
		current_signal = "hidden"

func get_box():
	return current_box

func set_box(index):
	if current_box != index:
		current_box = index
		Hook.hide()
		if 0 <= current_box && current_box < ALL_BOXES.size():
			add_style_override("panel", ALL_BOXES[current_box])
		else:
			hide_box()

func set_hook(character, center):
	# Verify if showing a hook is even possible
	if 0 <= get_box() && get_box() < Hook.get_vframes():
		# Positioning the hook
		set_hook_pos(center)
		Hook.set_frame(get_box())
		Hook.show()
	else:
		Hook.hide()

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
