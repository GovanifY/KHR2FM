extends CanvasLayer

# Constants & Classes
const TextScroll = preload("res://SCRIPTS/TextScroll.gd")

# Instance members
onready var ConfirmIcon = get_node("ConfirmIcon")
onready var Skin        = get_node("Skin")
onready var Anchor      = get_node("Skin/Anchor")
var TextBox = null


######################
### Core functions ###
######################

###############
### Methods ###
###############
func init(dialogue):
	# Setting TextBox-related data
	TextBox = TextScroll.new()
	TextBox.set_text_node(get_node("TextContainer"))
	add_child(TextBox)
	TextBox.set_name("TextScroll")

	# Connecting signals to parent
	# TODO: connect animations
	TextBox.connect("cleared", dialogue, "_next_line")

# Some wrappers
func set_bubble_skin(index):
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

# is_ functions
# TODO

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
