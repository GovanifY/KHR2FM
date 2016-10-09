extends CanvasLayer

# Export values
export(String, FILE, "csv") var csv_path = ""
export(String) var dialogue_context = ""
export(int, "Speech", "Narration") var initial_skin = -1

# Signals
signal no_more_lines

# Constants & Classes
const Translator = preload("res://SCRIPTS/Translator.gd")

# Instance members
onready var Bubble = get_node("Bubble")
var DialogueTranslation = null

# "Private" members
var current_speaker = {
	"name"  : null,
	"begin" : 0,
	"index" : -1,
	"end"   : 0
}

######################
### Core functions ###
######################
func _ready():
	if csv_path.get_file().empty():
		print("No CSV file set. Global lines will be loaded.")

	# Initializing Translator
	DialogueTranslation = Translator.new(csv_path)
	add_child(DialogueTranslation)

	# Initializing assets
	Bubble.init(self, initial_skin)

func _input(event):
	# Pressed, non-repeating Input check
	if event.is_pressed() && !event.is_echo():
		if event.is_action("enter"):
			Bubble.hit_confirm()

	# Pressed, repeating Input check
	elif event.is_pressed() && event.is_echo():
		if event.is_action("fast-forward"):
			Bubble.hit_confirm()

func _close_dialogue():
	# Resetting values
	current_speaker.index = -1
	current_speaker.name  = null

	set_process_input(false)
	emit_signal("no_more_lines")

#######################
### Signal routines ###
#######################
func _get_line():
	if !is_processing_input():
		set_process_input(true)

	# Parsing lineID
	var lineID = ""
	if !current_speaker.name.empty():
		lineID += current_speaker.name + "_"
	if !dialogue_context.empty():
		lineID += dialogue_context + "_"
	lineID += "%02d" % current_speaker.index

	# Incrementing index
	current_speaker.index += 1

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
	return (current_speaker.begin <= current_speaker.index
		&& current_speaker.index <= current_speaker.end)

# Makes a character speak.
func speak(name, begin, end):
	# Check arguments
	if name == null || (end - begin) < 0:
		return
	# Check if speak() has been issued already
	if is_loaded():
		print("speak() isn't finished yet!")
		return

	current_speaker.name  = name.to_upper()
	current_speaker.index = begin
	current_speaker.begin = begin
	current_speaker.end   = end
	_get_line()

func silence():
	# TODO: hide ConfirmIcon
	# TODO: fade bubble
	Bubble.set_bubble_skin(-1)
