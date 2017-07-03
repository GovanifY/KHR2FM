extends Timer

# Signals
signal started
signal finished
signal cleared

# Exported variables
export(NodePath) var text_node  = NodePath("..")
export(Sample) var character_sound
export(Sample) var confirm_sound

# "Private" members
onready var SoundNode = SamplePlayer.new()
var TextNode

######################
### Core functions ###
######################
func _ready():
	# Connecting signals
	connect("timeout", self, "_on_TextScroll_timeout")

	# Setting up the text node to scroll
	set_text_node(get_node(text_node))

	# Setting up Sound node
	var library = SampleLibrary.new()
	if character_sound != null:
		library.add_sample("character", character_sound)
	if confirm_sound != null:
		library.add_sample("confirm", confirm_sound)

	SoundNode.set_sample_library(library)
	SoundNode.set_polyphony(5)

func _on_TextScroll_timeout():
	# In case all characters have been written
	if TextNode.get_visible_characters() >= TextNode.get_total_character_count():
		stop()
		return

	TextNode.set_visible_characters(TextNode.get_visible_characters() + 1)
	play_se("character")

func start():
	.start()
	emit_signal("started")

func stop():
	.stop()
	emit_signal("finished")

###############
### Methods ###
###############
# Sets the node to use when scrolling. Mandatory
func set_text_node(node):
	if node.is_type("Label") || node.is_type("RichTextLabel"):
		TextNode = node
		TextNode.set_visible_characters(0)
	else:
		TextNode = null
		print("TextScroll: Text node was not set!")

# Plays given sound name if it's set
func play_se(sound_name):
	if SoundNode.get_sample_library().has_sample(sound_name):
		SoundNode.play(sound_name)

# Adds new text to scroll, then starts scrolling immediately
func scroll(text_to_use):
	# Parsing newlines
	text_to_use = text_to_use.replace("\\n", "\n")

	# Setting text
	set_text_raw(text_to_use)
	set_visibility_raw(1)
	start()

# Checks whether to stop or to clear the text node
func confirm():
	if is_processing(): # if we're still writing, write everything
		TextNode.set_visible_characters(-1)
		stop()
	else: # if we're done writing, clear everything
		TextNode.set_visible_characters(0)
		play_se("confirm")
		emit_signal("cleared")

func set_text_raw(text):
	if TextNode.is_type("RichTextLabel"):
		TextNode.set_bbcode(text)
	elif TextNode.is_type("Label"):
		TextNode.set_text(text)

func set_visibility_raw(visibility):
	TextNode.set_visible_characters(visibility)
