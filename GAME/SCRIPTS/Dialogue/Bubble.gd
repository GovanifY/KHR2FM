extends CanvasLayer

# Constants
const TextScroll = preload("res://GAME/SCRIPTS/TextScroll.gd")

onready var ALL_BUBBLES = [
	get_node("Narrator"),
	get_node("Speech")
]
onready var ALL_ANCHORS = [
	get_node("Speech/anchor_left"),
	get_node("Speech/anchor_right")
]

# Instance members
var This = {
	"text_box" : null,
	"node"    : null,
	"anchor"  : null,
	"anims"   : {
		"fadein"  : null,
		"fadeout" : null
	}
}

###############
### Methods ###
###############
func init(dialogue, confirmkey):
	# Filling bubble
	This.node = get_bubble_skin(0)
	This.anchor = get_anchor(false)
	This.anchor.show()
	This.anims.fadein = get_node("FadeIn")
	This.anims.fadeout = get_node("FadeOut")

	# Setting This.text_box-related data
	This.text_box = TextScroll.new()
	This.text_box.set_name("TextScroll")
	This.text_box.set_text_node(get_node("TextBox"))
	add_child(This.text_box)

	# Connecting signals to parent
	This.anims.fadein.connect("finished", dialogue, "_get_line")
	This.anims.fadeout.connect("finished", dialogue, "emit_signal", ["no_more_lines"])
	This.text_box.connect("cleared", dialogue, "_next_line")
	This.text_box.connect("started", confirmkey, "stop_anim")
	This.text_box.connect("finished", confirmkey, "play_anim")

func update_anchor(side):
	This.anchor.hide()
	This.anchor = get_anchor(side)
	This.anchor.show()

# Some wrappers
func set_bubble_skin(type):
	if typeof(type) == TYPE_STRING:
		type = ["Narrator", "Speech"].find(type)

	# Safety measure
	assert(0 <= type && type < ALL_BUBBLES.size())
	This.node = get_bubble_skin(type)

func get_bubble_skin(type):
	return ALL_BUBBLES[type]

func get_anchor(side):
	return ALL_ANCHORS[int(side)]

func set_modulate(mod):
	for type in ALL_BUBBLES:
		type.set_modulate(mod)
	for anchor in ALL_ANCHORS:
		anchor.set_modulate(mod)

# is_ functions
func is_narrator():
	return This.node == get_bubble_skin(0)

func is_speaker():
	return This.node == get_bubble_skin(1)

# Animation control
func play_anim():
	This.anims.fadein.play(This.node.get_name())

func stop_anim():
	This.anims.fadeout.play(This.node.get_name())

# Sneds "confirm" action to TextScroll
func hit_confirm():
	This.text_box.confirm()

# Sends line to TextScroll
func write(line):
	This.text_box.scroll(line)
