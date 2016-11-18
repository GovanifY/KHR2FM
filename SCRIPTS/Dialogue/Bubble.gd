extends Panel

# Skin data
const ALL_SKINS = [
	preload("res://SCENES/Dialogue/box0.tres"),
	preload("res://SCENES/Dialogue/box1.tres")
]

# Instance members
onready var Hook        = get_node("Hook")
onready var ConfirmIcon = get_node("ConfirmIcon")
onready var TextBox     = get_node("TextContainer/TextScroll")

######################
### Core functions ###
######################

###############
### Methods ###
###############
func set_skin(index):
	# Hiding bubble
	hide()
	Hook.hide()

	# Switching, then showing bubble
	if 0 <= index && index < ALL_SKINS.size():
		add_style_override("panel", ALL_SKINS[index])
		show()
	if 0 <= index && index < Hook.get_vframes():
		Hook.set_frame(index)
		Hook.show()

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
