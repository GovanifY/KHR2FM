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
onready var Overflow   = get_node("InfoLabel/Overflow")

onready var info_font = Info.get("custom_fonts/font")

# Private members
enum { LEFT, RIGHT }
var display_direction = RIGHT
var displayed_pos = 0

const END_DELAY = 1.0
var wait_time = 0


######################
### Core functions ###
######################
func _ready():
	Overflow.connect("timeout", self, "_overflow")
	if autostart:
		call_deferred("play")

func _input(event):
	# Avoid repeated key captures
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_accept"):
			TextScroll.confirm()

func _overflow():
	# Delays function each time the text reaches each side
	if wait_time < END_DELAY:
		wait_time += Overflow.get_wait_time()
		return

	var displayed_text = info_message.substr(displayed_pos, info_message.length())
	var length = info_font.get_string_size(displayed_text).width
	TextScroll.set_text_raw(displayed_text)

	if display_direction == RIGHT && length >= Info.get_size().width:
		displayed_pos += 1
	elif display_direction == LEFT && displayed_text != info_message:
		displayed_pos -= 1
	else:
		display_direction = LEFT if display_direction == RIGHT else RIGHT
		wait_time = 0

###############
### Methods ###
###############
func set_text(text):
	info_message = text

func play():
	var length = info_font.get_string_size(info_message).width

	# Display info bar
	Slide.play("In")
	yield(Slide, "finished")
	emit_signal("displayed")

	# Start scrolling text. Partially if it's too long
	TextScroll.scroll(info_message)
	yield(TextScroll, "finished")

	# Accept input to dismiss info bar
	set_process_input(true)
	if length >= Info.get_size().width:
		displayed_pos = 0
		wait_time = 0
		Overflow.start()
	yield(TextScroll, "cleared")

	# Dismiss info bar
	set_process_input(false)
	Overflow.stop()
	Slide.play("Out")
	yield(Slide, "finished")
	emit_signal("dismiss")
