extends Node

# Signals
signal displayed
signal dismiss

# Export values
export(String, MULTILINE) var info_message = "INFO_BATTLE_MESSAGE"
export(bool) var autostart = true

# Instance members
onready var Slide      = get_node("Slide")
onready var Constraint = get_node("Constraint")

onready var Info       = get_node("Constraint/InfoLabel")
onready var TextScroll = Info.get_node("TextScroll")
onready var Overflow   = Info.get_node("Overflow")
onready var Delay      = Info.get_node("Delay")

# Private members
const DURATION = 1.0 # FIXME: Shouldn't be a fixed value

######################
### Core functions ###
######################
func _ready():
	# Setting text slide animation
	Constraint.set_h_scroll(0)
	Overflow.connect("tween_complete", self, "_on_Overflow_end")

	# Firing it up
	if autostart:
		call_deferred("play")

func _input(event):
	# Avoid repeated key captures
	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_accept"):
			TextScroll.confirm()

func _on_Overflow_end(_, _):
	Delay.start()
	yield(Delay, "timeout")

	# If it's at the far left, start sliding right
	if Constraint.get_h_scroll() == 0:
		var length = Info.get_size().width - Constraint.get_size().width
		Overflow.interpolate_method(
			Constraint, "set_h_scroll", 0, length, DURATION,
			Overflow.TRANS_LINEAR, Overflow.EASE_IN
		)
	else:
		Overflow.interpolate_method(
			Constraint, "set_h_scroll", Constraint.get_h_scroll(), 0, DURATION,
			Overflow.TRANS_LINEAR, Overflow.EASE_IN
		)

	Overflow.call_deferred("start")

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

	# Start scrolling text.
	TextScroll.scroll(info_message)
	yield(TextScroll, "finished")

	# Accept input to dismiss info bar
	set_process_input(true)
	if Info.get_size().width >= Constraint.get_size().width:
		_on_Overflow_end(null, null)
	yield(TextScroll, "cleared")

	# Dismiss info bar
	set_process_input(false)
	Overflow.stop_all()
	Slide.play("Out")
	yield(Slide, "finished")
	emit_signal("dismiss")
