extends ScrollContainer

# Signals
signal loaded

# Paths to save images
const PATH_IMG_WORLD  = "res://ASSETS/GFX/Title/MainMenu/Save/Worlds/"
const PATH_IMG_AVATAR = "res://ASSETS/GFX/Title/MainMenu/Save/Avatars/"

# Instance members
onready var Scroll = get_node("Scroll")
onready var Slots  = get_node("Slots")

onready var save_template = get_node("Slots/Save")

######################
### Core functions ###
######################
func _ready():
	save_template.hide()
	save_template.set_text("")

func _recenter(button):
	var y = int(button.get_pos().y)
	Scroll.interpolate_method(
		self, "set_v_scroll", get_v_scroll(), y, 0.1,
		Scroll.TRANS_LINEAR, Scroll.EASE_IN
	)
	Scroll.start()

###############
### Methods ###
###############
func fetch_saves(cb_node, callback):
	for filename in SaveManager.get_save_list():
		var slot_idx = int(filename)
		var data = SaveManager.get_save(slot_idx)
		if data.empty(): # Save file doesn't exist (only happens in debug)
			continue

		var node = save_template.duplicate(true)
		node.set_name(filename)
		node.add_to_group("Saves")
		node.connect("focus_enter", self, "_recenter", [node])
		node.connect("pressed", cb_node, callback, [node, slot_idx])

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

# Free all instanced save nodes
func cleanup():
	get_tree().call_group(0, "Saves", "queue_free")
