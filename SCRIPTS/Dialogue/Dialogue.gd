extends CanvasLayer

# Export values
export(String, FILE, "csv") var csv_path = ""
export(int, "Speech", "Narration") var initial_skin = -1
export(int, "Top", "Middle", "Bottom") var initial_position = 2
export(Sample) var confirm_sound
export(Sample) var character_sound

# Signals
signal no_more_lines

# Instance members
onready var SE_node    = get_node("SFX")
onready var Bubble     = get_node("Bubble")
onready var Translator = get_node("Translator")

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
	# Initializing Translator
	Translator.init(csv_path)

	# Initializing Bubble
	Bubble.init(self)
	Bubble.set_skin(initial_skin)
	Bubble.set_bubble_pos(initial_position)

	# Initializing sound
	if confirm_sound != null:
		SE_node.get_sample_library().add_sample("Confirm", confirm_sound)
	if character_sound != null:
		SE_node.get_sample_library().add_sample("Character", character_sound)
		Bubble.TextBox.set_sound_node(SE_node)

func _input(event):
	# Pressed, non-repeating Input check
	if event.is_pressed() && !event.is_echo():
		if event.is_action("enter"):
			Bubble.TextBox.confirm()

	# Pressed, repeating Input check
	elif event.is_pressed() && event.is_echo():
		if event.is_action("fast-forward"):
			Bubble.TextBox.confirm()

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
	# Parsing lineID
	var lineID = ""
	if !current_speaker.name.empty():
		lineID += current_speaker.name + "_"
	lineID += "%02d" % current_speaker.index

	# Incrementing index
	current_speaker.index += 1

	# Writing line to bubble
	Bubble.TextBox.scroll(Translator.translate(lineID))

func _next_line():
	if confirm_sound != null:
		SE_node.play("Confirm")

	if is_loaded(): # Scroll next line
		_get_line()
	else: # No more lines, close everything
		_close_dialogue()

###############
### Methods ###
###############
# Sets a (new) CSV path
func set_csv(path):
	csv_path = path
	Translator.close()
	Translator.init(csv_path)

# Tells if there are still lines on hold.
func is_loaded():
	return (current_speaker.begin <= current_speaker.index
		&& current_speaker.index <= current_speaker.end)

# Makes a character speak.
func speak(name, begin, end):
	# Check arguments
	if typeof(name) != TYPE_STRING || (end - begin) < 0:
		return

	current_speaker.name  = name.to_upper()
	current_speaker.index = begin
	current_speaker.begin = begin
	current_speaker.end   = end

	set_process_input(true)
	_get_line()

func silence():
	# TODO: fade bubble
	set_process_input(false)
	Bubble.set_skin(-1)
