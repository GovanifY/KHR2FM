extends CanvasLayer

# Constants & Classes
const TextScroll = preload("res://SCRIPTS/TextScroll.gd")

# Instance members
onready var ConfirmIcon = get_node("ConfirmIcon")
onready var Skin        = get_node("Skin")
onready var Anchor      = get_node("Skin/Anchor")
onready var TextBox     = get_node("TextContainer/TextScroll")


######################
### Core functions ###
######################

###############
### Methods ###
###############
func init(dialogue, initial_skin):
	# Hiding nodes
	set_skin(initial_skin)

	# Setting TextBox
	TextBox.set_text_node(get_node("TextContainer"))
	TextBox.connect("cleared", dialogue, "_next_line")

	# TODO: connect animations

# Some wrappers
func set_skin(index):
	# Hiding bubble
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

func play_SE():
	pass

# Sends "confirm" action to TextScroll
func hit_confirm():
	TextBox.confirm()

# Sends line to TextScroll
func write(line):
	TextBox.scroll(line)
