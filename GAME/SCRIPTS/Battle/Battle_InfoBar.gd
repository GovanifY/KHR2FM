#extends anything

# Export Data
export(String) var InfoMessage = "BATTLE INFO MESSAGE"

# Managing the "Dismiss" signal
signal dismiss
# Info data
var Info = {
	"display" : false,
	"scroll" : false,
	"text" : null
}

# Really Important Nodes
const TextScroll = preload("res://GAME/SCRIPTS/TextScroll.gd")

func _can_display():
	Info.display = true

func display():
	if !Info.display:
		return

	if !Info.scroll:
		Info.text = TextScroll.new()
		Info.text.set_SE()
		Info.text.set_text_node(get_node("InfoLabel"))
		Info.text.scroll(InfoMessage)
		Info.scroll = true

	if Info.text.is_active():
		Info.text.update_text()
	else:
		get_node("Slide").play("Out")
		emit_signal("dismiss")
		Info.text.free()
		Info.text = null
	return

# InfoBar initializer
func init(messageID = null):
	if messageID:
		InfoMessage = messageID

	# L'InfoMessage n'est qu'un ID pour chercher la traduction
	InfoMessage = tr(InfoMessage)
	get_node("Slide").play("In")
	get_node("Slide").connect("finished", self, "_can_display")
