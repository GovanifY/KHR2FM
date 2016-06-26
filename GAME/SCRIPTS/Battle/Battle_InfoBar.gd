#extends anything

# Export Data
export(String) var InfoMessage = "BATTLE INFO MESSAGE"

# Managing the "Dismiss" signal
signal dismiss
# Info data
var Info = {
	"scroll" : false,
	"text" : null
}

# Really Important Nodes
onready var TextScroll = preload("res://GAME/SCRIPTS/TextScroll.gd")

func display():
	if !Info.scroll:
		Info.text = TextScroll.new()
		Info.text.set_SE()
		Info.text.scroll(get_node("Info_Label"), InfoMessage)
		Info.scroll = true

	if Info.text.is_active():
		Info.text.update_text()
	else:
		get_node("Info_Unpop").play("Info_Unpop")
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
	get_node("Info_Popup").play("Info_Popup")
