extends Container

# Export values
export(String, FILE, "csv") var csv_path = String()
export(int, "Top", "Middle", "Bottom") var position = 2
export(Sample) var confirm_sound = preload("res://ASSETS/SE/System/MSG_SOUND.wav")
export(Sample) var character_sound

# Signals
signal finished

# Instance members
onready var SE_node    = get_node("SE")
onready var SkinPos    = get_node("SkinPos")
onready var Bubble     = get_node("SkinPos/Bubble")

# "Private" members
var index = -1
var first = 0
var last  = 0
var current_speaker = null

######################
### Core functions ###
######################
func _ready():
	# Initializing Translator
	Translator.set_csv(csv_path)

	# Initializing Bubble
	set_alignment(position)

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

	# Touch events
	elif event.type == InputEvent.SCREEN_TOUCH:
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
# Sets Bubble alignment
func set_alignment(value):
	SkinPos.set_alignment(value)

# Tells if there are still lines on hold.
func is_loaded():
	return first <= index && index <= last

# Makes a character speak.
func speak(character, begin, end, right = false):
	# Check arguments
	assert(typeof(character) == TYPE_OBJECT && character.is_type("Character"))
	if (end - begin) < 0:
		print("Dialogue: Invalid indexes.")
		return

	# Setting text iteration values
	index = begin
	first = begin
	last  = end
	current_speaker = character

	# Setting skin properties
	Bubble.set_skin(character.type)

	# Fitting avatars in the Dialogue window
	# TODO: this is incomplete, finish the job
	fit_child_in_rect(character, get_rect())

	# Flipping sprites accordingly
	var flip = Bubble.set_hook_pos(character.get_center())
	character.set_flip_h(flip)

	# Presenting character and fetching line
	character.show()
	set_process_input(true)
	_get_line()

func silence():
	set_process_input(false)
	Bubble.set_skin(-1)
