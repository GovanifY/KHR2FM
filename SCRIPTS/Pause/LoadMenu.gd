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
	anims.connect("animation_started", self, "_on_animation_started")
	List.connect("finished", self, "_display_saves")

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
		Info.msg.set_text("MENU_SAVE_NOT_FOUND")
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

	Info.msg.set_text("MENU_SAVE_SLOTS_WAIT")
	anims.play("Show Info")
	List.fetch_saves(self, "_pressed")

func _on_animation_started(anim_name):
	if anim_name == "Fade Out":
		SE.play("system_dismiss")
		List.cleanup()

func _pressed(button):
	var slot_idx = int(button.get_name())

	# Avoiding cleaning up upon loading
	SaveManager.connect("loaded", anims, "disconnect", [
		"animation_started", self, "_on_animation_started"
	])
	SaveManager.connect("loaded", self, "_done")

	Info.msg.set_text("MENU_LOAD_WAIT")
	anims.play("Show Info")
	SaveManager.load_game(slot_idx)

func _done():
	if anims.is_playing():
		yield(anims, "finished")

	anims.play("Hide Info")
	yield(anims, "finished")

	emit_signal("finished")
