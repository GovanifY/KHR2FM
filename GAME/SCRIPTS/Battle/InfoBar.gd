# Signals
signal dismiss

# Instance members
onready var Slide = get_node("Slide")
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
	Slide.disconnect("finished", self, "_display")
	InfoText.scroll(message)
	Slide.connect("finished", self, "_end_dismissal")

func _start_dismissal():
	set_process_input(false)
	Slide.play("Out")

func _end_dismissal():
	Slide.disconnect("finished", self, "_end_dismissal")
	emit_signal("dismiss")

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
	InfoText.connect("cleared", self, "_start_dismissal")

func display(messageID):
	# Grabbing message from its ID
	var message = tr(messageID)
	Slide.connect("finished", self, "_display", [message])
	# Begin!
	Slide.play("In")
