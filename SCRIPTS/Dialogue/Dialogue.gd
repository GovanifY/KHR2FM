extends VBoxContainer

# Export values
export(String, FILE, "csv") var csv_path = String()
export(Sample) var confirm_sound = preload("res://ASSETS/SE/System/MSG_SOUND.wav")
export(Sample) var character_sound

# Signals
signal finished

# Instance members
onready var SE_node    = get_node("SE")
onready var Bubble     = get_node("Bubble")
onready var Translator = get_node("Translator")

# "Private" members
var index = -1
var current_speaker = null

######################
### Core functions ###
######################
func _ready():
	# Initializing Translator
	Translator.init(csv_path)

	# Initializing sound
	if confirm_sound != null:
		SE_node.get_sample_library().add_sample("Confirm", confirm_sound)
	if character_sound != null:
		SE_node.get_sample_library().add_sample("Character", character_sound)
		Bubble.TextBox.set_sound_node(SE_node)

func _input(event):
	# Pressed, non-repeating Input check
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_accept"):
			Bubble.TextBox.confirm()

	# Pressed, repeating Input check
	elif event.is_pressed() && event.is_echo():
		if event.is_action("fast-forward"):
			Bubble.TextBox.confirm()

func _close_dialogue():
	# Resetting values
	index = -1
	current_speaker = null

	set_process_input(false)
	emit_signal("finished")

#######################
### Signal routines ###
#######################
func _get_line():
	# Parsing lineID
	var lineID = ""
	if !current_speaker.name.empty():
		lineID += current_speaker.name.to_upper() + "_"
	lineID += "%02d" % index

	# Incrementing index
	index += 1

	# Writing line to bubble
	Bubble.TextBox.scroll(lineID)

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
	Translator.init(path)

# Tells if there are still lines on hold.
func is_loaded():
	return current_speaker.begin <= index && index <= current_speaker.end

# Makes a character speak.
func speak(character, begin, end):
	# Check arguments
	assert(typeof(character) == TYPE_OBJECT && character.is_type("Character"))
	if (end - begin) < 0:
		print("Dialogue: Invalid indexes.")
		return

	# Setting text iteration values
	index = begin
	current_speaker = character
	current_speaker.begin = begin
	current_speaker.end   = end

	# Setting skin properties
	Bubble.set_skin(character.type)
	var flip = Bubble.set_hook_pos(character.get_pos())
	character.set_flip_h(flip)

	# Presenting character and fetching line
	character.show()
	set_process_input(true)
	_get_line()

func silence():
	set_process_input(false)
	Bubble.set_skin(-1)
