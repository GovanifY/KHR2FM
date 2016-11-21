extends Timer

# Signals
signal started
signal finished
signal cleared

# Exported variables
export(NodePath) var text_node  = NodePath("..")
export(NodePath) var sound_node = NodePath()

# Constants
const SPEED_SLOWER = 0.04
const SPEED_SLOW   = 0.03
const SPEED_MEDIUM = 0.02
const SPEED_FAST   = 0.01
const SPEED_FASTER = 0.001

######################
### Core functions ###
######################
func _ready():
	# This automagically sets up this node to the attached text container
	set_text_node(get_node(text_node))
	set_sound_node(get_node(sound_node))
	set_wait_time(SPEED_FASTER)

func _on_TextScroll_timeout():
	# In case all characters have been written
	if text_node.get_visible_characters() >= text_node.get_total_character_count():
		_stop_scrolling()
		return

	text_node.set_visible_characters(text_node.get_visible_characters() + 1)
	if sound_node != null:
		sound_node.play("Character")

func _start_scrolling():
	start()
	emit_signal("started")

func _stop_scrolling():
	stop()
	emit_signal("finished")

###############
### Methods ###
###############
# Sets the node to use when scrolling. Mandatory
func set_text_node(node):
	if node.is_type("Label") || node.is_type("RichTextLabel"):
		text_node = node
	else:
		text_node = null
		print("TextScroll: Text node not set!")

func set_sound_node(node):
	if node.is_type("SamplePlayer") && node.get_sample_library().has_sample("Character"):
		sound_node = node
	else:
		sound_node = null
		print("TextScroll: Sound node not set!")

# Adds new text to scroll, then starts scrolling immediately
func scroll(texttouse):
	# If text_node is null or there's no text, forget it
	if text_node == null || texttouse.empty():
		return

	texttouse = texttouse.replace("\\n", "\n")
	if text_node.is_type("RichTextLabel"):
		text_node.set_bbcode(texttouse)
	elif text_node.is_type("Label"):
		text_node.set_text(texttouse)

	text_node.set_visible_characters(1)
	# Regenerate word cache to avoid performance drop during scroll
	text_node.get_total_character_count()

	_start_scrolling()

# Checks whether to stop or to clear the text node
func confirm():
	if is_processing(): # if we're still writing, write everything
		text_node.set_visible_characters(-1)
		_stop_scrolling()
	else: # if we're done writing, clear everything
		text_node.set_visible_characters(0)
		emit_signal("cleared")
