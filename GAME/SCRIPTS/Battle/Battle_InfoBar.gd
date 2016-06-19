#extends anything

# Managing the "Dismiss" signal
signal dismiss
var info_scroll = false

func display():
	if !info_scroll:
		# TODO: remove hardcoded values
		get_node("/root/global").textscroll(get_node("Info_Label"), tr("INTRO_INFO_YUUGURE"), null, null)
		info_scroll = true
	# Si le jouer a appuyé pour continuer, retirer la barre
	if !Globals.get("TextScrolling"):
		get_node("Info_Unpop").play("Info_Unpop")
		emit_signal("dismiss")


# InfoBar initializer
func init():
	get_node("Info_Popup").play("Info_Popup")
