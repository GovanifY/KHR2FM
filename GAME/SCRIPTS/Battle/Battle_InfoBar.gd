#extends anything

# Export Data
export(String) var InfoMessage = "BATTLE INFO MESSAGE"

# Managing the "Dismiss" signal
signal dismiss
var info_scroll = false

func display():
	if !info_scroll:
		get_node("/root/global").textscroll(get_node("Info_Label"), InfoMessage, null, null)
		info_scroll = true
	# Si le jouer a appuyé pour continuer, retirer la barre
	if !Globals.get("TextScrolling"):
		get_node("Info_Unpop").play("Info_Unpop")
		emit_signal("dismiss")


# InfoBar initializer
func init(messageID):
	if messageID:
		InfoMessage = messageID
	# L'InfoMessage n'est qu'un ID pour chercher la traduction
	InfoMessage = tr(InfoMessage)
	get_node("Info_Popup").play("Info_Popup")
