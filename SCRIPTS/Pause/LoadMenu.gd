extends Panel

# Signals
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
	connect("hide", self, "_hide")

	anims.connect("animation_started", self, "_on_fade_out")
	List.connect("finished", self, "_display_saves")

func _display_saves():
	if anims.is_playing():
		yield(anims, "finished")

	# Do we have any saves in here?
	if List.Slots.get_child_count() > 1:
		if Info.panel.is_visible():
			hide_info()
			yield(anims, "finished")

		anims.play("Show Saves")
		yield(anims, "finished")

		# Making sure the first Option is selected
		List.Slots.get_child(1).grab_focus()
	else:
		show_info("MENU_SAVE_NOT_FOUND")
		yield(anims, "finished")

#######################
### Signal routines ###
#######################
# When this window is shown
func _show():
	if anims.is_playing():
		yield(anims, "finished")
	show_info("MENU_SAVE_SLOTS_WAIT")

	List.fetch_saves(self, "_pressed")

func _hide():
	List.cleanup()

func _on_fade_out(name):
	if name == "Fade Out":
		SE.play("system_dismiss")

func _pressed(button):
	if !SaveManager.is_connected("loaded", self, "_done"):
		SaveManager.connect("loaded", self, "_done")

	var slot_idx = int(button.get_name())
	show_info("MENU_LOAD_WAIT")
	SaveManager.load_game(slot_idx)

func _done():
	if anims.is_playing():
		yield(anims, "finished")
	hide_info()
	yield(anims, "finished")

	emit_signal("finished")

###############
### Methods ###
###############
func show_info(msg, title="info"):
	Info.title.set_text(title)
	Info.msg.set_text(msg)
	anims.play("Show Info")

func hide_info():
	anims.play("Hide Info")
