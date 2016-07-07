extends Node

# Export values
# TODO

# Signals
signal no_more_lines

# Constants
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
var Bubble = {
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
	"side"    : false,  # false = left, true = right
	"specify" : false
}
var CurrentSpeaker = {
	"name"  : null,
	"count" : 0
}

# Global values
var dialogue_context = ""
var text_collection = {}

######################
### Core functions ###
######################
func _ready():
	# Filling bubble
	Bubble.node = _get_bubble(0)
	Bubble.anchor = _get_anchor()
	Bubble.anchor.show()
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
		if event.is_action("enter"):
			Bubble.text.confirm()

# Some wrappers
func _get_bubble(type):
	return ALL_BUBBLES[type]

func _get_anchor():
	return ALL_ANCHORS[int(Mugshot.side)]

func _switch_side():
	if !Mugshot.side:
		print("Switching to right")
	else:
		print("Switching to left")
	Bubble.anchor.hide()
	Mugshot.side = !Mugshot.side
	Bubble.anchor = _get_anchor()
	Bubble.anchor.show()

func _has_speaker():
	return (CurrentSpeaker.name != null && !CurrentSpeaker.name.empty()
		&& Bubble.node == _get_bubble(1))

func _open_dialogue():
	# Revealing current bubble setup
	Bubble.anims.fadein.play(Bubble.node.get_name())

func _close_dialogue():
	set_process_input(false)

	# Cleaning bubble
	Bubble.anims.fadeout.play(Bubble.node.get_name())
	_hide_keyblade()

func _translate():
	var name = ""
	if !CurrentSpeaker.name.empty():
		name = CurrentSpeaker.name + "_"

	var index = text_collection[CurrentSpeaker.name].index
	# ID format: (CHARACTER_)GAME_CONTEXT_COUNT
	# ID example 1: INTRO_FATHERSON_00
	# ID example 2: KIRYOKU_INTRO_FATHERSON_00
	var lineID = name + dialogue_context + "_%02d" % index

	# Incrementing index
	text_collection[CurrentSpeaker.name].index += 1

	return tr(lineID)

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
	if !is_processing_input():
		set_process_input(true)

	CurrentSpeaker.count -= 1
	Bubble.text.scroll(_translate())

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

###############
### Methods ###
###############
# Sets up a character to speak for X lines
func speak(characterID, count):
	# Safety assertions
	assert(characterID != null)
	assert(typeof(count) == TYPE_INT && count > 0)
	assert(dialogue_context != null && !dialogue_context.empty())

	# Fetching our character information
	characterID = characterID.to_upper()
	# If this character doesn't exist, avoid speaking
	if !text_collection.has(characterID):
		return
	var character = text_collection[characterID]

	# Count must not go overboard; if it does, decrease it to a minimum
	var is_overboard = (character.index + count) > character.count
	if is_overboard:
		count = character.count - character.index

	# If a side has been specified, do not switch here
	if Mugshot.specify:
		Mugshot.specify = false
	# If it has no current speaker, do not switch
	elif _has_speaker():
		if !CurrentSpeaker.name.matchn(characterID):
			_switch_side()

	# Setting up our current speaker
	CurrentSpeaker.name = characterID
	CurrentSpeaker.count = count

	_open_dialogue()

# Collects information that will permit translation afterwards
func collect_lines(characterID, count):
	# Safety assertions
	assert(characterID != null && typeof(characterID) == TYPE_STRING)
	assert(typeof(count) == TYPE_INT && count > 0)

	characterID = characterID.to_upper()

	# Assigning input values to this character
	text_collection[characterID] = {
		"index"   : 0,
		"count"   : count
	}

# Checks if there are lines left
func is_loaded():
	return CurrentSpeaker.count > 0

# Sets the game context to load in real time when speaking
func set_context(context):
	assert(typeof(context) == TYPE_STRING && !context.empty())
	dialogue_context = context

# Sets bubble type
func set_bubble_type(type):
	if typeof(type) == TYPE_STRING:
		type = ["Narrator", "Speech"].find(type)

	# Safety measure
	assert(0 <= type && type < ALL_BUBBLES.size())
	Bubble.node = _get_bubble(type)

# Sets the side to position the anchor
func set_side(side):
	assert(typeof(side) == TYPE_STRING)

	# Sets to true if side is "right"; false otherwise as a failsafe
	if Mugshot.side != side.matchn("right"):
		Mugshot.specify = true
		_switch_side()

# Adds a new sound effect to use when confirming
func set_SE(SENode = null, SEName = null):
	# If ANY of them are null, use the default SE
	if SENode == null || SEName == null:
		SENode = get_node("Confirm")
		SEName = "MSG_SOUND"
	ConfirmKey.SE.node = SENode
	ConfirmKey.SE.name = SEName
