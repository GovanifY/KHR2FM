extends Node

# Export values
export(String, FILE, "csv") var csv_path = null
export(Color, RGBA) var bubble_mod = null

# Signals
signal no_more_lines

# Constants
const PATH_MUGSHOTS = "res://GAME/SCENES/Dialogue/Mugshots/"
const Speaker = preload("res://GAME/SCRIPTS/Dialogue/speaker.gd")
const Translator = preload("res://GAME/SCRIPTS/Translator.gd")

# Instance members
onready var Bubble = get_node("Bubble")
onready var ConfirmKey = get_node("ConfirmKey")
onready var Mugshots = get_node("Mugshots")
var TranslatedLines = null

var CurrentSpeaker = {
	"count"   : 0,
	"name"    : null
}

# Global values
var dialogue_context = ""
var speaker_collection = {}

######################
### Core functions ###
######################
func _ready():
	# Initializing assets
	Bubble.init(self, ConfirmKey)
	if bubble_mod != null:
		Bubble.set_modulate(bubble_mod)
	Mugshots.init(self)
	TranslatedLines = Translator.new(csv_path)
	add_child(TranslatedLines)

func _input(event):
	# Pressed, non-repeating Input check
	if event.is_pressed() && !event.is_echo():
		if event.is_action("enter"):
			Bubble.hit_confirm()

	# Pressed, repeating Input check
	elif event.is_pressed() && event.is_echo():
		if event.is_action("fast-forward"):
			Bubble.hit_confirm()

# Some wrappers
func _has_speaker():
	return (CurrentSpeaker.name != null && !CurrentSpeaker.name.empty())

func _open_dialogue():
	Bubble.play_anim()

func _close_dialogue():
	set_process_input(false)
	ConfirmKey.stop_anim()
	Bubble.stop_anim()

#######################
### Signal routines ###
#######################
func _get_line():
	if !is_processing_input():
		set_process_input(true)

	CurrentSpeaker.count -= 1
	Bubble.write(translate())

func _next_line():
	ConfirmKey.play_SE()

	if is_loaded():
		# Scroll next line
		_get_line()
	else:
		# No more lines, close everything
		_close_dialogue()

###############
### Methods ###
###############
# Translates lines
func translate(lineID = null):
	# If given lineID is null, fetch CurrentSpeaker's next line
	if lineID == null:
		var name = ""
		if !CurrentSpeaker.name.empty():
			name = CurrentSpeaker.name + "_"

		var character = get_character(CurrentSpeaker.name)
		# ID format: (CHARACTER_)GAME_CONTEXT_COUNT
		# ID example 1: INTRO_FATHERSON_00
		# ID example 2: KIRYOKU_INTRO_FATHERSON_00
		lineID = name + dialogue_context + "_%02d" % character.index
		# Incrementing index
		character.index += 1

	# Grabbing the translation with lineID
	return TranslatedLines.translate(lineID)

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

	# Setting bubble skin
	if characterID.empty() && !Bubble.is_narrator():
		Bubble.set_bubble_skin("Narrator")
	elif !characterID.empty() && !Bubble.is_speaker():
		Bubble.set_bubble_skin("Speech")

	# Count must not go overboard; if it does, decrease it to a minimum
	var is_overboard = (character.index + count) > character.count
	if is_overboard:
		count = character.count - character.index

	# If a side has been specified, do not switch here
	if Mugshots.is_specified():
		Mugshots.set_specify(false)
	# If it has no current speaker, do not switch
	elif _has_speaker():
		if !CurrentSpeaker.name.matchn(characterID):
			Mugshots.switch_side()
			Bubble.update_anchor(Mugshots.get_side())

	# Setting up our current speaker
	CurrentSpeaker.name = characterID.to_upper()
	CurrentSpeaker.count = count
	var manual = Mugshots.switch_character(character)

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
			Mugshots.add_child(mugshot)

	# Assigning input values to this character
	speaker_collection[characterID.to_upper()] = Speaker.new(characterID, count, mugshot)

# Checks if there are lines left
func is_loaded():
	return CurrentSpeaker.count > 0

# Sets the game context to load in real time when speaking
func set_context(context):
	assert(typeof(context) == TYPE_STRING && !context.empty())
	dialogue_context = context

# Sets bubble type
func set_bubble_type(type):
	Bubble.set_bubble(type)

func set_bubble_modulate(r, g, b, a = 255):
	Bubble.set_modulate(Color(r, g, b, a))

# Sets the side to position the anchor
func set_side(side):
	assert(typeof(side) == TYPE_STRING)

	# Sets to true if side is "right"; false otherwise as a failsafe
	if Mugshots.get_side() != side.matchn("right"):
		Mugshots.set_specify(true)
		Mugshots.switch_side()
		Bubble.update_anchor(Mugshots.get_side())

# Adds a new sound effect to use when confirming
func set_SE(SENode = null, SEName = null):
	ConfirmKey.set_SE(SENode, SEName)

# Sets which frame to use to a character's mugshot
func set_character_frame(characterID, frame):
	assert(typeof(frame) == TYPE_INT)
	var character = get_character(characterID)
	if character == null:
		return
	character.mugshot.set_frame(frame)

# Grabs the wanted character
func get_character(characterID):
	assert(typeof(characterID) == TYPE_STRING)
	characterID = characterID.to_upper()
	if !speaker_collection.has(characterID):
		print("WARNING: Character \"%s\" does not exist" % characterID)
		return null
	return speaker_collection[characterID]
