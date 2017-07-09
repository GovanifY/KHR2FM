extends Node

# Signals
signal displayed
signal dismiss

# Export values
export(String, MULTILINE) var info_message = "INFO_BATTLE_MESSAGE"
export(bool) var autostart = true

# Instance members
onready var Slide      = get_node("Slide")
onready var Info       = get_node("InfoLabel")
onready var TextScroll = get_node("InfoLabel/TextScroll")

# Private members
const MAX_VISIBLE_CHARS = 30

enum { DIR_LEFT, DIR_RIGHT }
var display_direction = DIR_RIGHT
var displayed_pos = 0

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

func _process(delta):
	accumulator+=delta
	if accumulator > 1:
		if is_changing:
			accumulator = 0
			is_changing = false

		if accumulator > 1.05:
			TextScroll.set_text_raw(info_message.substr(displayed_pos, displayed_pos+MAX_VISIBLE_CHARS))
			if display_direction == DIR_RIGHT && (displayed_pos+MAX_VISIBLE_CHARS)<(info_message.length()+1):
				displayed_pos+=1
				accumulator = 1
			elif display_direction == DIR_LEFT && (displayed_pos+1>1):
				displayed_pos-=1
				accumulator = 1
			else:
				display_direction = !display_direction
				is_changing = true

###############
### Methods ###
###############
func set_text(text):
	info_message = text

func play():
	# Display info bar
	Slide.play("In")
	yield(Slide, "finished")
	emit_signal("displayed")

	# Start scrolling text. Partially if it's too long
	if info_message.length() > 30:
		displayed_pos=0
		TextScroll.scroll(info_message.substr(0, MAX_VISIBLE_CHARS))
		Info.set_visible_characters(MAX_VISIBLE_CHARS)
	else:
		TextScroll.scroll(info_message)
	yield(TextScroll, "finished")

	# Accept input to dismiss info bar
	set_process_input(true)
	if info_message.length() > MAX_VISIBLE_CHARS:
		set_process(true)
	yield(TextScroll, "cleared")

	# Dismiss info bar
	set_process_input(false)
	set_process(false)
	Slide.play("Out")
	yield(Slide, "finished")
	emit_signal("dismiss")
