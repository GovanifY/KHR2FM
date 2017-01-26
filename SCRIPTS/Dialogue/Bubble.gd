extends Panel

# Signals
signal shown
signal hidden

# Skin data
const ALL_SKINS = [
	preload("res://SCENES/Dialogue/box0.tres"),
	preload("res://SCENES/Dialogue/box1.tres"),
	preload("res://SCENES/Dialogue/box2.tres")
]

# Instance members
onready var Fade       = get_node("Fade")
onready var Hook       = get_node("Hook")
onready var TextScroll = get_node("TextContainer/TextScroll")
var current = -1

######################
### Core functions ###
######################
func _ready():
	get_node("TextContainer").set_visible_characters(0)

###############
### Methods ###
###############
func show_skin():
	Fade.play("In")
	yield(Fade, "finished")
	emit_signal("shown")

func hide_skin():
	Fade.play("Out")
	yield(Fade, "finished")
	emit_signal("hidden")

func get_skin():
	return current

func set_skin(index):
	current = index
	# Switching hook
	if 0 <= index && index < Hook.get_vframes():
		Hook.set_frame(index)
		Hook.show()
	else:
		Hook.hide()

	# Switching bubble
	if 0 <= index && index < ALL_SKINS.size():
		add_style_override("panel", ALL_SKINS[index])

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
