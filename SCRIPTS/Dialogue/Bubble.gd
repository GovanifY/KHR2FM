extends CanvasLayer

# Instance members
onready var ConfirmIcon = get_node("ConfirmIcon")
onready var Skin        = get_node("Skin")
onready var Anchor      = get_node("Skin/Anchor")
onready var TextBox     = get_node("TextContainer/TextScroll")

# "Private" members
var SE_node = null

######################
### Core functions ###
######################

###############
### Methods ###
###############
func init(dialogue):
	# Initializing Confirm Sound Effect
	SE_node = ConfirmIcon.get_node("Click")

	# Setting Hover animation
	ConfirmIcon.get_node("Hover").play("Down_Up")
	# Connecting signals
	TextBox.connect("cleared", dialogue, "_next_line")
	TextBox.connect("started", ConfirmIcon, "hide")
	TextBox.connect("finished", ConfirmIcon, "show")

# Some wrappers
func set_skin(index):
	# Hiding bubble
	ConfirmIcon.hide()
	Skin.hide()
	Anchor.hide()

	# Switching, then showing bubble
	if 0 <= index && index < Skin.get_vframes():
		Skin.set_frame(index)
		Skin.show()
	if 0 <= index && index < Anchor.get_vframes():
		Anchor.show()
		Anchor.set_frame(index)

func set_modulate(mod):
	Skin.set_modulate(mod)
	Anchor.set_modulate(mod)

# Animation control
# TODO

# Confirm Sound Effect control
func play_SE(name = "MSG_SOUND"):
	if SE_node != null:
		SE_node.play(name)
