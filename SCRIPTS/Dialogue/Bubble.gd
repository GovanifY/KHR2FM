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

func set_box(idx):
	if current_box == idx:
		return

	Hook.hide()
	if 0 <= idx && idx < ALL_BOXES.size():
		current_box = idx
		add_style_override("panel", ALL_BOXES[current_box])
	else:
		current_box = -1
		hide_box()

func set_hook(idx=get_box()):
	# Verify if showing a hook is even possible
	if 0 <= idx && idx < Hook.get_vframes():
		# Positioning the hook
		Hook.set_frame(idx)
		Hook.show()
	else:
		Hook.hide()

func set_hook_pos(x):
	var limit_left  = get_margin(MARGIN_LEFT)
	var limit_right = get_margin(MARGIN_RIGHT)

	# Subtracting Bubble's current global position since X is global
	x -= get_global_pos().x

	# Flip depending on where it sits on the screen
	var flip = x > (int(limit_right) >> 1)
	Hook.set_flip_h(flip)

	if x < limit_left:
		x = limit_left
	elif x > limit_right:
		x = limit_right

	Hook.set_pos(Vector2(x, 0))

func set_modulate(mod):
	get_stylebox("panel").set_modulate(mod)
	Hook.set_modulate(mod)
