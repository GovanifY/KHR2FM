extends Node

# Signals
signal displayed
signal dismiss

# Export values
export(String, MULTILINE) var info_message = "INFO_BATTLE_MESSAGE"
export(bool) var autostart = true

# Constants
const MAX_VISIBLE_CHARS = 30

# Instance members
onready var Slide      = get_node("Slide")
onready var Info       = get_node("InfoLabel")
onready var TextScroll = get_node("InfoLabel/TextScroll")

# Private members
var displayed_text = ""
var displayed_pos = 0

## True: Scrolling to the right
## False: Scrolling to the left
var display_direction = true

var accumulator = 0

var is_changing = false


######################
### Core functions ###
######################
func _ready():
	if autostart:
		call_deferred("play")

func _input(event):
	# Avoid repeated key captures
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_accept"):
			TextScroll.confirm()

func _fixed_process(delta):
	accumulator+=delta
	if accumulator > 1:
		if is_changing:
			accumulator = 0
			is_changing = false

		if accumulator > 1.05 && accumulator != 0:
			if display_direction == true && (displayed_pos+MAX_VISIBLE_CHARS)<(info_message.length()+1):
				displayed_pos+=1
				accumulator = 1
				TextScroll.set_text_raw(info_message.substr(displayed_pos, displayed_pos+MAX_VISIBLE_CHARS))
				TextScroll.set_visibility_raw(MAX_VISIBLE_CHARS)
			elif display_direction == false && (displayed_pos+1>1):
				displayed_pos-=1
				accumulator = 1
				TextScroll.set_text_raw(info_message.substr(displayed_pos, displayed_pos+MAX_VISIBLE_CHARS))
				TextScroll.set_visibility_raw(MAX_VISIBLE_CHARS)
			else:
				display_direction = !display_direction
				is_changing = true

###############
### Methods ###
###############
func play():
	# Display info bar
	Slide.play("In")
	yield(Slide, "finished")
	emit_signal("displayed")

	# Start scrolling text. Partially if it's too long
	Info.set_text(info_message)
	var clipping = Info.is_clipping_text()
	if clipping:
		displayed_text = info_message.substr(0, MAX_VISIBLE_CHARS)
		displayed_pos=0
		TextScroll.scroll(displayed_text)
	else:
		TextScroll.scroll(info_message)
	yield(TextScroll, "finished")

	# Accept input to dismiss info bar
	set_process_input(true)
	if clipping:
		set_fixed_process(true)
	yield(TextScroll, "cleared")

	# Dismiss info bar
	set_process_input(false)
	Slide.play("Out")
	yield(Slide, "finished")
	emit_signal("dismiss")
