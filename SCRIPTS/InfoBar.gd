extends Node
# Signals
signal displayed
signal dismiss

# Export values
export(String, MULTILINE) var info_message = "INFO_BATTLE_MESSAGE"
export(bool) var autostart = true

var displayed_text = ""
var displayed_pos = 0

## True: Scrolling to the right
## False: Scrolling to the left
var display_direction = true

var accumulator = 0

var is_changing = false

# Instance members
onready var Slide      = get_node("Slide")
onready var TextScroll = get_node("InfoLabel/TextScroll")

######################
### Core functions ###
######################
func _ready():
	# Connecting signals
	TextScroll.connect("finished", self, "_start_input")
	TextScroll.connect("cleared", self, "_start_dismissal")

	if autostart:
		play()

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
			if display_direction == true && (displayed_pos+30)<(info_message.length()+1):
				displayed_pos+=1
				accumulator = 1
				TextScroll.set_text_raw(info_message.substr(displayed_pos, displayed_pos+30))
				TextScroll.set_visibility_raw(30)
			elif display_direction == false && (displayed_pos+1>1):
				displayed_pos-=1
				accumulator = 1
				TextScroll.set_text_raw(info_message.substr(displayed_pos, displayed_pos+30))
				TextScroll.set_visibility_raw(30)
			else:
				display_direction = !display_direction
				is_changing = true

#######################
### Signal routines ###
#######################
func _display():
	emit_signal("displayed")
	Slide.disconnect("finished", self, "_display")
	if info_message.length() > 30:
		displayed_text = info_message.substr(0, 30)
		displayed_pos=0
		TextScroll.scroll(displayed_text)
	else:
		TextScroll.scroll(info_message)

func _start_input():
	set_process_input(true)
	if info_message.length() > 30:
		set_fixed_process(true)

func _start_dismissal():
	set_process_input(false)
	Slide.connect("finished", self, "_end_dismissal")
	Slide.play("Out")

func _end_dismissal():
	Slide.disconnect("finished", self, "_end_dismissal")
	emit_signal("dismiss")

###############
### Methods ###
###############
func set_text(text):
	info_message = text

func play():
	Slide.connect("finished", self, "_display")
	Slide.play("In")
