#extends anything

# Signals
signal dismiss

# Instance members
var InfoText = null

# Really Important Nodes
const TextScroll = preload("res://GAME/SCRIPTS/TextScroll.gd")

######################
### Core functions ###
######################
func _input(event):
	# Avoid repeated key captures
	if event.is_pressed() && !event.is_echo():
		if event.is_action("enter"):
			InfoText.confirm()

#######################
### Signal routines ###
#######################
func _display(message):
	var slide = get_node("Slide")
	slide.disconnect("finished", self, "_display")
	InfoText.scroll(message)
	slide.connect("finished", self, "emit_signal", ["dismiss"])

func _dismiss():
	set_process_input(false)
	get_node("Slide").play("Out")

###############
### Methods ###
###############
# InfoBar initializer
func init():
	# Instancing TextScroll
	InfoText = TextScroll.new()
	InfoText.set_text_node(get_node("InfoLabel"))
	add_child(InfoText)

	# Connecting signals
	InfoText.connect("finished", self, "set_process_input", [true])
	InfoText.connect("cleared", self, "_dismiss")

func display(messageID):
	# Grabbing message from its ID
	var message = tr(messageID)
	get_node("Slide").connect("finished", self, "_display", [message])
	# Begin!
	get_node("Slide").play("In")
