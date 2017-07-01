extends Panel

# Signals
signal finished

enum INFO_PANEL_SIZE { INFO_SIZE_SMALL, INFO_SIZE_MEDIUM, INFO_SIZE_LARGE }

# Instance members
onready var anims  = get_node("Anims")

onready var List = get_node("List")
onready var Info = {
	"panel"   : get_node("Info"),
	"title"   : get_node("Info/Title"),
	"content" : get_node("Info/Contents"),
	"msg"     : get_node("Info/Contents/Message"),
}

######################
### Core functions ###
######################
func _ready():
	# Initial settings
	Info.panel.hide()
	connect("draw", self, "_show")
	connect("hide", self, "_hide")

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
	set_info_size(INFO_SIZE_SMALL)
	show_info("MENU_SAVE_SLOTS_WAIT")

	List.fetch_saves(self, "_pressed", "_hide")

func _hide():
	if !anims.is_playing():
		anims.play("Fade Out")
		yield(anims, "finished")
	List.cleanup()

func _pressed(button):
	if !SaveManager.is_connected("loaded", self, "_done"):
		SaveManager.connect("loaded", self, "_done")

	List.set_disabled_slots(true)

	var slot_idx = int(button.get_name())
	show_info("MENU_LOAD_WAIT")
	SaveManager.load_game(slot_idx)

func _done():
	if anims.is_playing():
		yield(anims, "finished")
	hide_info()
	yield(anims, "finished")

	emit_signal("finished")

	if !anims.is_playing():
		List.set_disabled_slots(false)

###############
### Methods ###
###############
func set_info_size(size):
	if size == INFO_SIZE_SMALL:
		Info.panel.set_pos(Vector2(227, 140))
		Info.panel.set_size(Vector2(400, 160))
	elif size == INFO_SIZE_MEDIUM:
		Info.panel.set_pos(Vector2(197, 120))
		Info.panel.set_size(Vector2(460, 200))
	elif size == INFO_SIZE_LARGE:
		Info.panel.set_pos(Vector2(127, 120))
		Info.panel.set_size(Vector2(600, 200))

func show_info(msg, title="info"):
	Info.title.set_text(title)
	Info.msg.set_text(msg)
	if Info.panel.is_hidden():
		anims.play("Show Info")

func hide_info():
	if Info.panel.is_visible():
		anims.play("Hide Info")
