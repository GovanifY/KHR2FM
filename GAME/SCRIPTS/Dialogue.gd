extends Node

# Export values
# TODO

# Signals
signal no_more_lines

# Constants
const PATH_MUGSHOTS = "res://ASSETS/GFX/Game/Mugshots/"
const TextScroll = preload("res://GAME/SCRIPTS/TextScroll.gd")

onready var ALL_ANCHORS = [
	get_node("Bubble/Speech/anchor_left"),
	get_node("Bubble/Speech/anchor_right")
]
onready var ALL_BUBBLES = [
	get_node("Bubble/Narrator"),
	get_node("Bubble/Speech")
]

# Instance members
onready var Bubble = {
	"text"    : null,
	"node"    : null,
	"anchor"  : null,
	"anims"   : {
		"fadein"  : null,
		"fadeout" : null
	}
}
var ConfirmKey = {
	"SE" : {
		"name" : null,
		"node" : null
	},
	"anims"    : null,
	"icon"     : null
}
var Mugshot = {
	"side"  : false  # false = left, true = right
}

var SelfInput = {
	"confirm" : false
}

# Global values
var TextCollection = []

######################
### Core functions ###
######################
func _ready():
	# Filling bubble
	Bubble.node = _get_bubble(0)
	Bubble.anchor = _get_anchor()
	Bubble.anims.fadein = get_node("Bubble/FadeIn")
	Bubble.anims.fadeout = get_node("Bubble/FadeOut")

	# Preparing confirm key
	ConfirmKey.icon = get_node("MiniKeyblade")
	ConfirmKey.anims = get_node("MiniKeyblade/anims")

	# Setting text-related data
	Bubble.text = TextScroll.new()
	Bubble.text.set_name("TextScroll")
	add_child(Bubble.text)
	Bubble.text.set_text_node(get_node("TextBox"))

	# Connecting signals
	Bubble.anims.fadein.connect("finished", self, "_get_line")
	Bubble.anims.fadeout.connect("finished", self, "emit_signal", ["no_more_lines"])
	Bubble.text.connect("started", self, "_hide_keyblade")
	Bubble.text.connect("finished", self, "_show_keyblade")
	Bubble.text.connect("cleared", self, "_next_line")

	# Setting default SE
	set_SE()

func _input(event):
	# Avoid repeated key captures
	if event.is_pressed() && !event.is_echo():
		SelfInput.confirm = event.is_action("enter")

func _process(delta):
	if SelfInput.confirm:
		SelfInput.confirm = false
		# TextScroll confirm
		Bubble.text.confirm()
	pass

# Some wrappers
func _get_anchor():
	return ALL_ANCHORS[int(Mugshot.side)]

func _get_bubble(type):
	return ALL_BUBBLES[type]

func _open_dialogue():
	# Revealing current bubble setup
	Bubble.anims.fadein.play(Bubble.node.get_name())

	set_process_input(true)
	set_process(true)

func _close_dialogue():
	# Cleaning bubble
	Bubble.anims.fadeout.play(Bubble.node.get_name())
	_hide_keyblade()

	set_process_input(false)
	set_process(false)

#######################
### Signal routines ###
#######################
func _show_keyblade():
	ConfirmKey.icon.show()
	ConfirmKey.anims.play("Keyblade Hover")

func _hide_keyblade():
	ConfirmKey.anims.stop()
	ConfirmKey.icon.hide()

func _get_line():
	Bubble.text.scroll(_translate(TextCollection[0]))
	TextCollection.pop_front()

func _next_line():
	# Play SE
	if ConfirmKey.SE.node != null:
		ConfirmKey.SE.node.play(ConfirmKey.SE.name)

	if is_loaded():
		# Scroll next line
		_get_line()
	else:
		# No more lines, close everything
		_close_dialogue()

########################
### Helper functions ###
########################
static func _translate(stringID):
	return tr(stringID)

###############
### Methods ###
###############
# Collects a bunch of IDs to later scroll their translated counterparts
func collect(prefix, finish, start = 0):
	assert(typeof(prefix) == TYPE_STRING)
	assert(typeof(start) == TYPE_INT && typeof(finish) == TYPE_INT)
	assert(start <= finish)

	while start <= finish:
		# ID format: PASSAGE_NAME_##
		TextCollection.push_back((prefix + "_%02d") % start)
		start+=1

	_open_dialogue()
	return

# Checks if there are lines left
func is_loaded():
	return TextCollection.size() > 0

# A bunch of setters
func set_bubble_type(type):
	if typeof(type) == TYPE_STRING:
		type = ["Narrator", "Speech"].find(type)

	# Security measure
	assert(0 <= type && type < ALL_BUBBLES.size())
	Bubble.node = _get_bubble(type)

# Adds a new sound effect to use when confirming
func set_SE(SENode = null, SEName = null):
	# If ANY of them are null, use the default SE
	if SENode == null || SEName == null:
		SENode = get_node("Confirm")
		SEName = "MSG_SOUND"
	ConfirmKey.SE.node = SENode
	ConfirmKey.SE.name = SEName

# Helpers
func switch_side():
	Bubble.anchor.hide()
	Mugshot.side = !Mugshot.side
	Bubble.anchor = _get_anchor()
	Bubble.anchor.show()
