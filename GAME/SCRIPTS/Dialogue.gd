extends Node

# Export values
# TODO

# Signals
signal no_more_lines

# Constants
const PATH_MUGSHOTS = "res://GAME/SCENES/Dialogue/Mugshots/"
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
	"side"      : false,  # false = left, true = right
	"specify"   : false,
	"posx"      : [0, 0],
	"nodes"     : [null, null],
	"anim_show" : null
}
var CurrentSpeaker = {
	"count"   : 0,
	"name"    : null
}

# Global values
var dialogue_context = ""
var text_collection = {}
# For reference, text_collection works like this:
# text_collection[characterID] = {
#	"index"   : 0,
#	"count"   : count,
#	"mugshot" : mugshot
#}

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

	# Preaparing mugshot info
	Mugshot.posx[1] = OS.get_window_size().width - 440

	# Setting text-related data
	Bubble.text = TextScroll.new()
	Bubble.text.set_name("TextScroll")
	Bubble.text.set_text_node(get_node("TextBox"))
	add_child(Bubble.text)

	# Connecting signals
	Bubble.anims.fadein.connect("finished", self, "_get_line")
	Bubble.anims.fadeout.connect("finished", self, "emit_signal", ["no_more_lines"])
	Bubble.text.connect("started", self, "_hide_keyblade")
	Bubble.text.connect("finished", self, "_show_keyblade")
	Bubble.text.connect("cleared", self, "_next_line")
	get_node("Mugshots/SlideIn").connect("finished", self, "_open_dialogue")

	# Setting default SE
	set_SE()

func _input(event):
	# Pressed, non-repeating Input check
	if event.is_pressed() && !event.is_echo():
		if event.is_action("enter"):
			Bubble.text.confirm()
	# Pressed, repeating Input check
	elif event.is_pressed() && event.is_echo():
		if event.is_action("fast-forward"):
			Bubble.text.confirm()

# Some wrappers
func _get_bubble(type):
	return ALL_BUBBLES[type]

func _get_anchor():
	return ALL_ANCHORS[int(Mugshot.side)]

func _switch_side():
	Mugshot.side = !Mugshot.side
	# Setting anchor
	Bubble.anchor.hide()
	Bubble.anchor = _get_anchor()
	Bubble.anchor.show()

func _switch_mugshot(character):
	if character.mugshot == null:
		return true

	var i = int(Mugshot.side)
	# if it contains a node but is the same as argument
	if Mugshot.nodes[i] == character.mugshot:
		return true
	# if we need to switch a previously stored mugshot
	elif Mugshot.nodes[i] != null:
		Mugshot.nodes[i].hide()

	# Make the switch
	Mugshot.nodes[i] = character.mugshot
	Mugshot.nodes[i].set_flip_h(Mugshot.side)
	# Show it
	_anim_mugshot_in(character)
	Mugshot.nodes[i].show()
	return false

func _anim_mugshot_in(character, anim_node = "SlideIn"):
	var i = int(Mugshot.side)
	var from = _get_slide_name(i)
	var anim_player = get_node("Mugshots/" + anim_node)
	var anim = anim_player.get_animation(from)

	# If the animation can't be loaded, just set its position
	if anim == null:
		Mugshot.nodes[i].set_pos(Vector2(Mugshot.posx[i], 0))
		return

	# Setting NodePath
	var path = character.name + ":transform/pos"
	anim.track_set_path(0, path)

	# Playing the animation
	Mugshot.nodes[i].set_pos(Vector2(-440, 0))
	anim_player.play(from)

func _anim_mugshot_out(character, anim_node):
	var i = int(Mugshot.side)
	var anim = get_node("Mugshots/" + anim_node).get_animation("Normal")

	# If the animation can't be loaded, just hide it
	if anim == null:
		Mugshot.nodes[i].hide()
		return

	# Setting NodePath
	var path = character.name + ":visibility/opacity"
	anim.track_set_path(0, path)

	# Playing the animation
	Mugshot.anims.hidedown.play("Normal")

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

	var character = get_character(CurrentSpeaker.name)
	# ID format: (CHARACTER_)GAME_CONTEXT_COUNT
	# ID example 1: INTRO_FATHERSON_00
	# ID example 2: KIRYOKU_INTRO_FATHERSON_00
	var lineID = name + dialogue_context + "_%02d" % character.index
	# Incrementing index
	character.index += 1

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

########################
### Helper functions ###
########################
static func _get_slide_name(side):
	if !side:
		return "Left"
	else:
		return "Right"

###############
### Methods ###
###############
# Sets up a character to speak for X lines
func speak(characterID, count):
	# Safety assertions
	assert(characterID != null)
	assert(typeof(count) == TYPE_INT && count > 0)
	assert(dialogue_context != null && !dialogue_context.empty())

	# Fetching our character information. If this character doesn't exist, avoid speaking
	var character = get_character(characterID)
	if character == null:
		return

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
	CurrentSpeaker.name = characterID.to_upper()
	CurrentSpeaker.count = count
	var manual = _switch_mugshot(character)

	# At the end of the animation, it should start speaking
	if manual:
		_open_dialogue()

# Collects information that will permit translation afterwards
func collect_lines(characterID, count):
	# Safety assertions
	assert(characterID != null && typeof(characterID) == TYPE_STRING)
	assert(typeof(count) == TYPE_INT && count > 0)

	# Preparing mugshot (if available)
	var mugshot = null
	if !characterID.empty():
		var path = PATH_MUGSHOTS + characterID.capitalize() + ".tscn"
		# If the path leads to a file (why isn't there an exists() function?)
		if !path.get_file().empty():
			mugshot = load(path)
			mugshot = mugshot.instance()
			mugshot.hide()
			get_node("Mugshots").add_child(mugshot)

	# Assigning input values to this character
	text_collection[characterID.to_upper()] = {
		"name"    : characterID,
		"index"   : 0,
		"count"   : count,
		"mugshot" : mugshot
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

# Sets which frame to use to a character's mugshot
func set_mugshot_frame(characterID, frame):
	assert(typeof(frame) == TYPE_INT)
	var character = get_character(characterID)
	if character == null:
		return
	character.mugshot.set_frame(frame)

# Grabs the wanted character
func get_character(characterID):
	assert(typeof(characterID) == TYPE_STRING)
	characterID = characterID.to_upper()
	if !text_collection.has(characterID):
		print("WARNING: Character \"%s\" does not exist" % characterID)
		return null
	return text_collection[characterID]
