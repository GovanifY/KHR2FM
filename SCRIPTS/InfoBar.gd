extends Node

# Signals
signal displayed
signal dismiss

# Export values
export(String, MULTILINE) var info_message = "INFO_BATTLE_MESSAGE"
export(bool) var autostart = true
export(bool) var autoclose = false

# Instance members
onready var Autoclose  = get_node("Autoclose")
onready var Slide      = get_node("Slide")
onready var Constraint = get_node("Constraint")

onready var Info       = get_node("Constraint/InfoLabel")
onready var TextScroll = Info.get_node("TextScroll")
onready var Overflow   = Info.get_node("Overflow")
onready var Delay      = Info.get_node("Delay")

# Duration-related
const DURATION_PER_CHAR = 0.02
var duration

######################
### Core functions ###
######################
func _ready():
	# Setting text slide animation
	Overflow.connect("tween_complete", self, "_on_Overflow_end")

	# Final setup
	set_text(info_message)
	if autostart:
		call_deferred("play")

func _input(event):
	# Avoid repeated key captures
	if (event.is_pressed() && !event.is_echo()) && event.is_action("ui_accept"):
		TextScroll.confirm()

func _on_Overflow_end(_, _):
	Delay.start()
	yield(Delay, "timeout")

	# If it's at the far left, start sliding right
	if Constraint.get_h_scroll() == 0:
		var length = Info.get_size().width - Constraint.get_size().width
		Overflow.interpolate_method(
			Constraint, "set_h_scroll", 0, length, duration,
			Overflow.TRANS_LINEAR, Overflow.EASE_IN
		)
	else:
		Overflow.interpolate_method(
			Constraint, "set_h_scroll", Constraint.get_h_scroll(), 0, duration,
			Overflow.TRANS_LINEAR, Overflow.EASE_IN
		)

	Overflow.call_deferred("start")

###############
### Methods ###
###############
func set_text(text):
	Info.set_text(text)
	duration = DURATION_PER_CHAR * text.length()
	var close_in = max(2 * (duration + Delay.get_wait_time()), 3)
	Autoclose.set_wait_time(close_in)

func set_autoclose(value):
	autoclose = value

func play():
	Constraint.set_h_scroll(0)

	# Display info bar
	Slide.play("In")
	yield(Slide, "finished")
	emit_signal("displayed")

	# Start scrolling text
	Info.set_visible_characters(0)
	TextScroll.start()
	yield(TextScroll, "finished")

	# Wait until info bar is dismissed
	if Info.get_size().width >= Constraint.get_size().width:
		_on_Overflow_end(null, null)

	set_process_input(!autoclose)
	if autoclose:
		Autoclose.start()
		yield(Autoclose, "timeout")
		Overflow.stop_all()

		Delay.start()
		yield(Delay, "timeout")
		TextScroll.call_deferred("confirm")
	else:
		Overflow.stop_all()

	yield(TextScroll, "cleared")

	# Dismiss info bar
	set_process_input(false)
	Slide.play("Out")
	yield(Slide, "finished")
	emit_signal("dismiss")
