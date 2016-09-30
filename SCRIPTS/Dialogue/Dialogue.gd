extends CanvasLayer

# Export values
export(String, FILE, "csv") var csv_path = ""

# Signals
signal no_more_lines

# Constants & Classes
const Translator = preload("res://SCRIPTS/Translator.gd")
const Speaker = preload("res://SCRIPTS/Dialogue/Speaker.gd")

# Instance members
onready var Bubble = get_node("Bubble")
var DialogueTranslation = null
var SpeakerList = {}

# "Private" members
var counter = 0
var current_speaker = null
var dialogue_context = null

######################
### Core functions ###
######################
func _ready():
	if !csv_path.empty():
		if csv_path.is_rel_path() || csv_path.is_abs_path():
			_parse_dialogue()
	else:
		print("No CSV file present.")

	# Initializing assets
	Bubble.init(self)

	# Initializing Translator
	DialogueTranslation = Translator.new(csv_path)
	add_child(DialogueTranslation)

func _input(event):
	# Pressed, non-repeating Input check
	if event.is_pressed() && !event.is_echo():
		if event.is_action("enter"):
			Bubble.hit_confirm()

	# Pressed, repeating Input check
	elif event.is_pressed() && event.is_echo():
		if event.is_action("fast-forward"):
			Bubble.hit_confirm()

func _parse_dialogue():
	var dialogue = File.new()
	dialogue.open(csv_path, File.READ)

	# Skipping first line
	dialogue.get_csv_line()

	# Start parsing
	while !dialogue.eof_reached():
		var line = dialogue.get_csv_line()
		if line.size() > 1:
			# Analyze first entry. It's a formatted tag that contains our information
			# ID format: CHARACTER_GAME_CONTEXT_COUNT
			# ID example 1: KIRYOKU_INTRO_FATHERSON_00
			# ID example 2: KIOKU_TOWN_00
			var tag = line[0].split("_")

			# Extracting the name
			var name = tag[0]
			tag.remove(0)

			# Finding our speaker; if none found, creating a new one
			if !SpeakerList.has(name):
				SpeakerList[name] = Speaker.new(name)

			# Updating speaker's count
			SpeakerList[name].count += 1
			tag.remove(tag.size() - 1)

			# Forming the dialogue context. Must be done only once
			if dialogue_context == null:
				dialogue_context = ""
				for cat in tag:
					dialogue_context += cat + "_"
				dialogue_context = dialogue_context.substr(0, dialogue_context.length() - 1)

	dialogue.close()
	dialogue = null

func _close_dialogue():
	# Resetting values
	counter = 0
	current_speaker = null

	set_process_input(false)
	emit_signal("no_more_lines")

#######################
### Signal routines ###
#######################
func _get_line():
	if !is_processing_input():
		set_process_input(true)

	var lineID = current_speaker.name + "_" + dialogue_context + "_%02d" % current_speaker.index

	# Incrementing index
	current_speaker.index += 1
	counter -= 1

	# Writing line to bubble
	Bubble.write(DialogueTranslation.translate(lineID))

func _next_line():
	Bubble.play_SE()

	if is_loaded(): # Scroll next line
		_get_line()
	else: # No more lines, close everything
		_close_dialogue()

###############
### Methods ###
###############
# Tells if there are still lines on hold.
func is_loaded():
	return current_speaker != null && counter > 0

# Makes a character speak.
func speak(name, count = 1):
	if !is_loaded():
		current_speaker = SpeakerList[name.to_upper()]
		counter = count

	_get_line()

func silence():
	# TODO: hide ConfirmIcon
	Bubble.set_bubble_skin(-1)
