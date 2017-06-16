extends Panel

# Signals
signal error
signal finished

# Instance members
onready var anims  = get_node("Anims")

onready var List = get_node("List")
onready var Info = {
	"panel" : get_node("Info"),
	"title" : get_node("Info/Title"),
	"msg"   : get_node("Info/Message"),
}

######################
### Core functions ###
######################
func _ready():
	# Initial settings
	connect("draw", self, "_show")
	connect("hide", List, "cleanup")
	List.connect("loaded", self, "_display_saves")

func _display_saves():
	if anims.is_playing():
		yield(anims, "finished")

	# Do we have any saves in here?
	if List.Slots.get_child_count() > 1:
		# Making sure the first Option is selected
		List.Slots.get_child(1).grab_focus()

		if !Info.panel.is_hidden():
			anims.play("Hide Info")
			yield(anims, "finished")
		anims.play("Show Saves")
	else:
		Info.msg.set_text("TITLE_SAVE_NOT_FOUND")
		anims.play("Show Info")

#######################
### Signal routines ###
#######################
# When this window is shown
func _show():
	List.Slots.hide()
	Info.panel.hide()
	if anims.is_playing():
		yield(anims, "finished")

	Info.msg.set_text("TITLE_SAVE_WAIT")
	anims.play("Show Info")
	List.fetch_saves(self, "_pressed_load")

func _pressed_load(button):
	var slot_idx = int(button.get_name())
	var it_loaded = SaveManager.load_game(slot_idx)
	if it_loaded:
		button.release_focus()
	emit_signal("finished" if it_loaded else "error")
