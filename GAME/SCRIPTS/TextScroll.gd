extends Node

# Signals
signal started
signal finished

# Member instances
const FRAME_TEXT_WAIT = 1
var Text = {
	"node" : null,
	"timer" : 1,
	"length" : 0
}

######################
### Core functions ###
######################
func _process(delta):
	var chars_written = Text.node.get_visible_characters()

	# Check for timer: write a character if it's gone to 0, wait otherwise
	if Text.timer != 0:
		Text.timer-=1
	elif Text.timer == 0:
		Text.timer = FRAME_TEXT_WAIT
		if chars_written < Text.length:
			chars_written+=1
			Text.node.set_visible_characters(chars_written)

	# In case all characters have been drawn
	if chars_written == Text.length:
		_stop_scrolling()
		return

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
	Text.node = node

# Adds new text to scroll, then starts scrolling immediately
func scroll(texttouse):
	# If Text.node is null, forget it
	assert(Text.node != null);
	# If there's already text being displayed, do not replace it!
	if is_processing():
		print("TextScroll: Already scrolling text!")
		return
	# If there's no text, forget it as well
	if texttouse.empty():
		return

	texttouse = texttouse.replace("\\n", "\n")
	Text.node.set_bbcode(texttouse)
	Text.node.set_visible_characters(1)
	Text.length = Text.node.get_bbcode().length()

	_start_scrolling()

# Auto-checks whether to stop, or skip ahead
func confirm():
	var chars_written = Text.node.get_visible_characters()

	if is_processing():
		# if we're still writing, write everything
		chars_written = Text.length
		Text.node.set_visible_characters(chars_written)
		_stop_scrolling()
	else:
		# if we're done writing, clear everything
		Text.node.clear()
