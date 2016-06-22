#extends anything

# Export Data
export(String) var InfoMessage = "BATTLE INFO MESSAGE"

# Managing the "Dismiss" signal
signal dismiss
var info_scroll = false

# Really Important Nodes
onready var TextScroll = get_node("/root/TextScroll")

func display():
	if !info_scroll:
		TextScroll.set_SE()
		TextScroll.scroll(get_node("Info_Label"), InfoMessage)
		info_scroll = true
	# Si le jouer a appuyé pour continuer, retirer la barre
	if !TextScroll.is_active():
		get_node("Info_Unpop").play("Info_Unpop")
		emit_signal("dismiss")


# InfoBar initializer
func init(messageID = null):
	if messageID:
		InfoMessage = messageID

	# L'InfoMessage n'est qu'un ID pour chercher la traduction
	InfoMessage = tr(InfoMessage)
	get_node("Info_Popup").play("Info_Popup")
