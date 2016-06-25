extends Node

const FRAME_TEXT_WAIT = 1
var Text = {
	"node" : null,
	"enabled" : false,
	"end_line" : false,
	"timer" : 1,
	"length" : 0
}
var SE = {
	"node" : null,
	"name" : null
}

# Check scrolling status
func is_active():
	return Text.enabled

# Adds new sound effects to use
func set_SE(SENode = null, SEName = null):
	SE.node = SENode
	SE.name = SEName

# Adds new text to scroll
func scroll(node, texttouse):
	# Si le texte est en blanc, ignorer
	if texttouse.empty():
		return
	# Important assertions
	assert(node != null)

	Text.enabled = true
	Text.node = node

	texttouse = texttouse.replace("\\n", "\n")
	Text.node.set_bbcode(texttouse)
	Text.node.set_visible_characters(1)
	Text.length = Text.node.get_bbcode().length()

# Updates the text with the most recent line
func update_text():
	var chars_written = Text.node.get_visible_characters()

	# Are we in a hurry?
	var confirm = Input.is_action_pressed("enter")

	# Check for timer: write a character if it's gone to 0, wait otherwise
	if Text.timer != 0:
		Text.timer-=1
	elif Text.timer == 0:
		Text.timer = FRAME_TEXT_WAIT
		if chars_written < Text.length:
			chars_written+=1
			Text.node.set_visible_characters(chars_written)

	# If "enter" action was pressed:
	if confirm && !Text.end_line:
		# if we're still writing, write everything
		if chars_written < Text.length:
			chars_written = Text.length
			Text.node.set_visible_characters(chars_written)
			Text.end_line = true

		# if we're done writing, clear everything
		elif chars_written == Text.length:
			if SE.node != null:
				SE.node.play(SE.name)
			Text.node.clear()
			Text.enabled = false
			Text.end_line = true

	if !confirm && Text.end_line:
		Text.end_line = false
