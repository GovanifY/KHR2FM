extends Panel

# Hook constraints
# FIXME: Avoid fixed values like these
const HOOK_HEIGHT       = -21
const HOOK_LIMIT_LEFT   = 55
const HOOK_LIMIT_RIGHT  = 765
const HOOK_SWITCH_POINT = (HOOK_LIMIT_LEFT + HOOK_LIMIT_RIGHT) / 2

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
func _ready():
	# Setting Hover animation
	ConfirmIcon.get_node("Hover").play("Down_Up")

	# Connecting signals
	TextBox.connect("cleared", get_node(".."), "_next_line")
	TextBox.connect("cleared", ConfirmIcon, "hide")
	TextBox.connect("finished", ConfirmIcon, "show")


###############
### Methods ###
###############
func set_skin(index):
	# Hiding bubble
	ConfirmIcon.hide()
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
	# Search for a switch
	Hook.set_flip_h(x > HOOK_SWITCH_POINT)

	if x <= HOOK_LIMIT_LEFT:
		x = HOOK_LIMIT_LEFT
	elif HOOK_LIMIT_RIGHT < x:
		x = HOOK_LIMIT_RIGHT

	Hook.set_pos(Vector2(x, HOOK_HEIGHT))

func set_modulate(mod):
	get_stylebox("panel").set_modulate(mod)
	Hook.set_modulate(mod)
