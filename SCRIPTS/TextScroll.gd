extends Timer

# Signals
signal started
signal finished
signal cleared

# Exported variables
export(NodePath) var text_node  = NodePath("..")
export(NodePath) var sound_node = NodePath()
export(String) var character_sound = String()
export(String) var confirm_sound   = String()

######################
### Core functions ###
######################
func _ready():
	# Connects signals
	connect("timeout", self, "_on_TextScroll_timeout")

	# Sets up the text and sound nodes
	set_text_node(get_node(text_node))
	set_sound_node(get_node(sound_node))

func _on_TextScroll_timeout():
	# In case all characters have been written
	if text_node.get_visible_characters() >= text_node.get_total_character_count():
		_stop_scrolling()
		return

	text_node.set_visible_characters(text_node.get_visible_characters() + 1)
	_play_se(character_sound)

func _start_scrolling():
	start()
	emit_signal("started")

func _stop_scrolling():
	stop()
	emit_signal("finished")

func _play_se(sound_name):
	if sound_node != null && sound_node.get_sample_library().has_sample(sound_name):
		sound_node.play(sound_name)

###############
### Methods ###
###############
# Sets the node to use when scrolling. Mandatory
func set_text_node(node):
	if node.is_type("Label") || node.is_type("RichTextLabel"):
		text_node = node
		text_node.set_visible_characters(0)
	else:
		text_node = null
		print("TextScroll: Text node was not set!")

# Sets the node to use when playing sound effects. Optional
func set_sound_node(node):
	if node.is_type("SamplePlayer"):
		sound_node = node
	else:
		sound_node = null

# Adds new text to scroll, then starts scrolling immediately
func scroll(text_to_use):
	# Parsing newlines
	text_to_use = text_to_use.replace("\\n", "\n")

	# Setting text
	if text_node.is_type("RichTextLabel"):
		text_node.set_bbcode(text_to_use)
	elif text_node.is_type("Label"):
		text_node.set_text(text_to_use)

	text_node.set_visible_characters(1)
	_start_scrolling()

# Checks whether to stop or to clear the text node
func confirm():
	if is_processing(): # if we're still writing, write everything
		text_node.set_visible_characters(-1)
		_stop_scrolling()
	else: # if we're done writing, clear everything
		text_node.set_visible_characters(0)
		_play_se(confirm_sound)
		emit_signal("cleared")
