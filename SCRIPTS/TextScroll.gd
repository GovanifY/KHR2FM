extends Node

# Signals
signal started
signal finished
signal cleared

# Constants
const SPEED_SLOWER = 0.04
const SPEED_SLOW   = 0.03
const SPEED_MEDIUM = 0.02
const SPEED_FAST   = 0.01
const SPEED_FASTER = 0.001

# Member instances
var sound_node
var text_wait = SPEED_FASTER
var Text = {
	"node"   : null,
	"timer"  : 0,
	"length" : 0
}

######################
### Core functions ###
######################
func _ready():
	# This automagically sets up this node to the attached text container
	set_text_node(get_node(".."))

func _process(delta):
	# In case all characters have been written
	if Text.node.get_visible_characters() == Text.length:
		_stop_scrolling()

	# Check for timer
	Text.timer += delta
	if Text.timer >= text_wait:
		Text.timer = 0
		if Text.node.get_visible_characters() < Text.length:
			Text.node.set_visible_characters(Text.node.get_visible_characters() + 1)
			if sound_node != null:
				sound_node.play("Character")

func _start_scrolling():
	set_process(true)
	emit_signal("started")

func _stop_scrolling():
	set_process(false)
	emit_signal("finished")

###############
### Methods ###
###############
# Sets the node to use when scrolling. Mandatory
func set_text_node(node):
	if node.is_type("Label") || node.is_type("RichTextLabel"):
		Text.node = node
	else:
		print("TextScroll: Node not set!")

func set_sound_node(node):
	if node.is_type("SamplePlayer") && node.get_sample_library().has_sample("Character"):
		sound_node = node

# Sets the speed of the scrolling. Will limit to any of the two delimiters.
func set_text_speed(speed):
	if speed < SPEED_FASTER:
		speed = SPEED_FASTER
	elif speed > SPEED_SLOWER:
		speed = SPEED_SLOWER
	text_wait = speed

# Adds new text to scroll, then starts scrolling immediately
func scroll(texttouse):
	# If Text.node is null, forget it
	if Text.node == null:
		return
	# If there's no text, forget it as well
	if texttouse.empty():
		return

	texttouse = texttouse.replace("\\n", "\n")
	if Text.node.is_type("RichTextLabel"):
		Text.node.set_bbcode(texttouse)
		Text.node.set_scroll_active(false)
	elif Text.node.is_type("Label"):
		Text.node.set_text(texttouse)
		Text.node.set_autowrap(true)

	Text.node.set_visible_characters(1)
	Text.length = Text.node.get_text().length()

	_start_scrolling()

# Checks whether to stop or to clear the text node
func confirm():
	if is_processing(): # if we're still writing, write everything
		Text.node.set_visible_characters(-1)
		_stop_scrolling()
	else: # if we're done writing, clear everything
		Text.node.set_visible_characters(0)
		emit_signal("cleared")
