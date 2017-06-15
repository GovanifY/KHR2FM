extends Panel

# Signals
signal error
signal loaded
signal finished

# Paths to save images
const PATH_IMG_WORLD  = "res://ASSETS/GFX/Title/MainMenu/Save/Worlds/"
const PATH_IMG_AVATAR = "res://ASSETS/GFX/Title/MainMenu/Save/Avatars/"

# Instance members
onready var anims  = get_node("Anims")

onready var List   = get_node("List")
onready var Scroll = get_node("List/Scroll")
onready var Slots  = get_node("List/Slots")

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
	var save_template = Slots.get_node("Save")
	save_template.hide()
	save_template.set_text("")

	connect("draw", self, "_show")
	connect("loaded", self, "_display_saves")
	connect("hide", self, "_cleanup")

func _fetch_saves():
	var save_template = Slots.get_node("Save")

	for filename in SaveManager.get_save_list():
		var slot_idx = int(filename)
		var data = SaveManager.get_save(slot_idx)
		if data.empty(): # Save file doesn't exist (only happens in debug)
			continue

		var node = save_template.duplicate(true)
		node.set_name(filename)
		node.add_to_group("Saves")
		node.connect("focus_enter", self, "_recenter", [node])
		node.connect("pressed", self, "_pressed_load", [node, slot_idx])

		# Populating button with information
		var hrs  = String(data.playtime_hrs).pad_zeros(2)
		var mins = String(data.playtime_min).pad_zeros(2)
		var location = data.location if not data.location.empty() else "null"
		var difficulty = data.difficulty if data.difficulty != null else "null"
		var location = data.location if data.location != null else "null"

		var img_world = PATH_IMG_WORLD + data.world.to_lower() + ".png"
		var img_avatar = PATH_IMG_AVATAR + data.avatar.to_lower() + ".png"

		node.get_node("LV").set_text("LV." + String(data.lv))
		node.get_node("Difficulty").set_text(difficulty)
		node.get_node("Location").set_text(location)
		node.get_node("Playtime").set_text(hrs + ":" + mins)

		var img = File.new()
		if img.file_exists(img_world):
			node.get_node("World").set_texture(load(img_world))
		if img.file_exists(img_avatar):
			node.get_node("Avatar").set_texture(load(img_avatar))

		node.show()
		Slots.add_child(node)

	emit_signal("loaded")

func _display_saves():
	if anims.is_playing():
		yield(anims, "finished")

	# Do we have any saves in here?
	if Slots.get_child_count() > 1:
		# Making sure the first Option is selected
		Slots.get_child(1).grab_focus()

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
	Slots.hide()
	Info.panel.hide()
	if anims.is_playing():
		yield(anims, "finished")

	Info.msg.set_text("TITLE_SAVE_WAIT")
	anims.play("Show Info")
	_fetch_saves()

# When this window is dismissed
func _cleanup():
	get_tree().call_group(0, "Saves", "queue_free")

func _recenter(button):
	var y = int(button.get_pos().y)
	Scroll.interpolate_method(
		List, "set_v_scroll", List.get_v_scroll(), y, 0.1,
		Scroll.TRANS_LINEAR, Scroll.EASE_IN
	)
	Scroll.start()

func _pressed_load(button, slot_idx):
	var it_loaded = SaveManager.load_game(slot_idx)
	if it_loaded:
		button.release_focus()
	emit_signal("finished" if it_loaded else "error")
