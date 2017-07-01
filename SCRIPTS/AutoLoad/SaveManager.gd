extends Node

################################################################################
# This script serves as a data bank for any and all Save data (including but   #
# not limited to Stats, Inventory, Drives and Trophies).                       #
# This data can be serialized and channeled to Save files.                     #
################################################################################

signal loaded
signal saved

const SAVE_NAME = "slot"
const SAVE_EXT  = "save"

# Serializable dictionary filled with the most important info for a save file
var save_data = {}

######################
### Core functions ###
######################
func _exit_tree():
	# TODO: Emergency save file? i.e. in case the game is force killed on a mobile device
	pass

func _has_key(key):
	var has = save_data.has(key)
	if !has: print("SaveManager: Invalid key for save data.")
	return has

func _assemble_data():
	return {
		# IMPORTANT DATA
		"difficulty"   : Globals.get("Difficulty"),
		"scene"        : get_tree().get_current_scene().get_filename(),
		"world"        : Globals.get("World"),
		"location"     : Globals.get("Location"),
		"playtime_hrs" : Globals.get("PlayTimeHours"),
		"playtime_min" : Globals.get("PlayTimeMinutes"),

		# Save-specific content
		"avatar"       : random_avatar(),

		# Switches
		# Basic stats
		"lv"           : 1,
		"hp"           : 10,
		"attack"       : 1,
		"defense"      : 1,
		# Stat adders
		"keyblade"     : null,
		# TODO: Items, magic, abilities, limits
	}

########################
### Helper functions ###
########################
static func fmt_path(slot_idx):
	return "user://" + SAVE_NAME + String(slot_idx) + "." + SAVE_EXT

static func sort_by_date(filename1, filename2):
	var file = File.new()
	var time1 = file.get_modified_time("user://" + filename1)
	var time2 = file.get_modified_time("user://" + filename2)
	return time1 > time2

static func is_save_file(filename):
	return filename.begins_with(SAVE_NAME) && filename.extension() == SAVE_EXT

static func random_avatar():
	var dir = Directory.new()
	if dir.open("res://ASSETS/GFX/Title/MainMenu/Save/Avatars") != OK:
		return ""

	var list = []

	dir.list_dir_begin()
	var filename = dir.get_next()
	while (filename != ""):
		if !dir.current_is_dir():
			list.push_back(filename)
		filename = dir.get_next()

	if list.empty():
		return ""

	randomize()
	var rand = randi() % list.size()
	return list[rand]

static func read_save(path):
	var savegame = File.new()
	if !savegame.file_exists(path):
		return {} # We don't have a save to load

	savegame.open(path, File.READ) # FIXME: Open encrypted
	# FIXME: Save layout should be much more complicated than this
	var ret = savegame.get_var()
	# End layout
	savegame.close()

	return ret

static func write_save(path, data):
	var savegame = File.new()

	savegame.open(path, File.WRITE) # FIXME: Open encrypted
	# FIXME: Save layout should be much more complicated than this
	savegame.store_var(data)
	# End layout
	savegame.close()

####################
### Main Methods ###
####################
func find_available_slot():
	var list = get_save_list(false)
	for i in range(0, list.size()):
		var slot_idx = int(list[i])
		if i != slot_idx:
			return i
	return list.size()

func get_save(slot_idx):
	var path = fmt_path(slot_idx)
	return read_save(path)

func get_save_list(sort=true):
	var dir = Directory.new()
	if dir.open("user://") != OK:
		return -1

	var list = []

	dir.list_dir_begin()
	var filename = dir.get_next()
	while (filename != ""):
		if !dir.current_is_dir() && is_save_file(filename):
			list.push_back(filename)
		filename = dir.get_next()

	if sort: # This avoids needless CPU use
		list.sort_custom(self, "sort_by_date")

	return list

func get_save_count():
	return get_save_list(false).size()

# Wrapper functions
func new_game(difficulty, initial_scene = null):
	save_data.scene = initial_scene
	Globals.set("Difficulty", difficulty)
	KHR2.reset_playtime()
	return true

func load_game(slot_idx):
	save_data = get_save(slot_idx)
	KHR2.reset_playtime(save_data.playtime_min, save_data.playtime_hrs)

	emit_signal("loaded")
	return true

func save_game(slot_idx):
	save_data = _assemble_data()
	var path = fmt_path(slot_idx)
	write_save(path, save_data)

	emit_signal("saved")
	return true

func quick_load():
	var path = "user://" + "quick" + SAVE_NAME + "." + SAVE_EXT
	save_data = read_save(path)
	print("Quick loaded!")

func quick_save():
	save_data = _assemble_data()
	var path = "user://" + "quick" + SAVE_NAME + "." + SAVE_EXT
	write_save(path, save_data)
	print("Quick saved!")

####################
###   Modifiers  ###
####################
func get_value(key):
	if !_has_key(key):
		return
	return save_data[key]

func set_value(key, value):
	if !_has_key(key):
		return
	save_data[key] = value

# In addition to these above, you can write methods that have more verbose names
# so as to have more legible code when accessing this script.
func get_level(): return get_value("lv")
func set_level(value):   set_value("lv", value)

func get_scene(): return get_value("scene")
func set_scene(value):   set_value("scene", value)

func get_playtime(): return get_value("playtime")
func set_playtime(value):   set_value("playtime", value)
