extends CanvasLayer

# Export values
export(String, FILE, "csv") var csv_path = ""

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
var dialogue_context = null

######################
### Core functions ###
######################
func _ready():
	if !csv_path.empty() && (csv_path.is_rel_path() || csv_path.is_abs_path()):
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
	var dialogue_file = File.new()
	dialogue_file.open(csv_path, File.READ)

	# Grabbing dialogue_context
	while !dialogue_file.eof_reached():
		var line = dialogue_file.get_csv_line()
		if line.size() > 1:
			var left_index = line[0].find("_") + 1
			if left_index == 0:
				continue
			var right_index = line[0].find_last("_") - left_index
			# Analyze first entry. It's a formatted tag that contains our information
			dialogue_context = line[0].substr(left_index, right_index)
			break

	dialogue_file.close()
	dialogue_file = null

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

	# Parsing lineID and incrementing index
	var lineID = current_speaker.name + "_" + dialogue_context + "_%02d" % current_speaker.index
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
	if (end - begin) < 0:
		return
	# If speak() has been issued already
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
