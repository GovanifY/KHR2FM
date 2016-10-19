extends CanvasLayer

# Instance members
onready var Skin        = get_node("Skin")
onready var Anchor      = get_node("Skin/Anchor")
onready var ConfirmIcon = get_node("Skin/ConfirmIcon")
onready var TextBox     = get_node("Skin/TextContainer/TextScroll")

# "Private" members
var skin_positions = Vector2Array()

######################
### Core functions ###
######################
func _init_skin_positions():
	# Grabbing basic data
	var skin_width = Skin.get_texture().get_data().get_width()
	var skin_height = Skin.get_texture().get_data().get_height() / Skin.get_vframes()
	skin_positions.resize(3)
	skin_positions[2] = OS.get_video_mode_size()
	# 0 : Bottom
	# 1 : Middle
	# 2 : Bottom

	# Splitting screen into 3 subsections
	skin_positions[2].y /= 3
	# Calculating margin:
	# ((screen_height / 3) % skin_height) / 2
	var skin_margin = (int(skin_positions[2].y) % skin_height) >> 1

	# Setting X:
	# (screen_width - skin_width) / 2
	skin_positions[2].x = (int(skin_positions[2].x) - skin_width) >> 1
	skin_positions[1].x = skin_positions[2].x
	skin_positions[0].x = skin_positions[2].x

	# Setting Y
	# skin_margin + (screen_height / 3) * index
	skin_positions[0].y = skin_margin + (int(skin_positions[2].y) << 1)
	skin_positions[1].y = skin_margin + int(skin_positions[2].y)
	skin_positions[2].y = skin_margin

###############
### Methods ###
###############
func init(dialogue):
	# Setting skin positions (Top, Middle, Bottom)
	_init_skin_positions()

	# Setting Hover animation
	ConfirmIcon.get_node("Hover").play("Down_Up")

	# Connecting signals
	TextBox.connect("cleared", dialogue, "_next_line")
	TextBox.connect("cleared", ConfirmIcon, "hide")
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
		Anchor.set_frame(index)
		Anchor.show()

func set_position(index):
	if 0 <= index && index < skin_positions.size():
		Skin.set_pos(skin_positions[index])

func set_modulate(mod):
	Skin.set_modulate(mod)
	Anchor.set_modulate(mod)

# Animation control
# TODO
