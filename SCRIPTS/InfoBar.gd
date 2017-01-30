# Signals
signal displayed
signal dismiss

# Export values
export(String, MULTILINE) var info_message = "INFO_BATTLE_MESSAGE"
export(bool) var autostart = true

# Instance members
onready var Slide      = get_node("Slide")
onready var TextScroll = get_node("InfoLabel/TextScroll")

######################
### Core functions ###
######################
func _ready():
	# Connecting signals
	TextScroll.connect("finished", self, "set_process_input", [true])
	TextScroll.connect("cleared", self, "_start_dismissal")

	if autostart:
		play()

func _input(event):
	# Avoid repeated key captures
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_accept"):
			TextScroll.confirm()

#######################
### Signal routines ###
#######################
func _display():
	emit_signal("displayed")
	Slide.disconnect("finished", self, "_display")
	TextScroll.scroll(info_message)

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
