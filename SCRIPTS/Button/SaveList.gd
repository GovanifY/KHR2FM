extends ScrollContainer

# Signals
signal finished

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
# Slot control
func set_disabled_slots(value):
	get_tree().call_group(0, "Saves", "set_disabled", value)

# Slot creation
func new_slot(cb_node, on_press, on_cancel):
	var node = save_template.duplicate(true)
	node.add_to_group("Saves")
	node.connect("focus_enter", self, "_recenter", [node])
	node.connect("pressed", cb_node, on_press, [node])
	node.connect("cancel", cb_node, on_cancel)

	node.show()
	Slots.add_child(node)
	return node

func edit_slot(node, slot_info):
	# If slot_info is null, create an empty slot_info
	if slot_info == null:
		slot_info = {
			lv         = "",
			playtime   = "",
			location   = "",
			difficulty = "",
			img_world  = "",
			img_avatar = ""
		}

	# Setting text labels
	node.get_node("LV").set_text(slot_info.lv)
	node.get_node("Difficulty").set_text(slot_info.difficulty)
	node.get_node("Location").set_text(slot_info.location)
	node.get_node("Playtime").set_text(slot_info.playtime)

	# Setting images
	var img = File.new()
	var path_world = PATH_IMG_WORLD + slot_info.img_world + ".png"
	if img.file_exists(path_world):
		node.get_node("World").set_texture(load(path_world))

	var path_avatar = PATH_IMG_AVATAR + slot_info.img_avatar + ".png"
	if img.file_exists(path_avatar):
		node.get_node("Avatar").set_texture(load(path_avatar))

# Save information fetching (uses SaveManager)
func fetch_saves(cb_node, on_press, on_cancel):
	for filename in SaveManager.get_save_list():
		var slot_idx = int(filename)
		var data = SaveManager.get_save(slot_idx)
		if data.empty(): # Save file doesn't exist (only happens in debug)
			continue

		var node = new_slot(cb_node, on_press, on_cancel)
		node.set_name(filename)

		# Populating button with information
		var hrs  = String(data.get("playtime_hrs") if data.get("playtime_hrs") != null else 0).pad_zeros(2)
		var mins = String(data.get("playtime_min") if data.get("playtime_min") != null else 0).pad_zeros(2)

		var slot_info = {
			lv         = tr("LEVEL") + "." + String(data.get("lv") if data.get("lv") != null else 0),
			playtime   = hrs + ":" + mins,
			location   = var2str(data.get("location")),
			difficulty = var2str(data.get("difficulty")),
			img_world  = str(data.get("world")).to_lower(),
			img_avatar = str(data.get("avatar")).to_lower(),
		}

		edit_slot(node, slot_info)

	emit_signal("finished")

# Free all instanced save nodes
func cleanup():
	get_tree().call_group(0, "Saves", "queue_free")
