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

# SaveSlot class and current slot object
const SaveSlot = preload("SaveSlot.gd")
var current_slot

######################
### Core functions ###
######################
func _exit_tree():
	# TODO: Emergency save file? i.e. in case the game is force killed on a mobile device
	pass

func _ready():
	current_slot = SaveSlot.new()

########################
### Helper functions ###
########################
static func fmt_path(slot_idx):
	return "user://" + SAVE_NAME + String(slot_idx) + "." + SAVE_EXT

# Sorting function, sorts filenames by date
static func sort_by_date(filename1, filename2):
	var file = File.new()
	var time1 = file.get_modified_time("user://" + filename1)
	var time2 = file.get_modified_time("user://" + filename2)
	return time1 > time2

# Determines if filename follows a set name format
static func is_save_file(filename):
	return filename.begins_with(SAVE_NAME) && filename.extension() == SAVE_EXT

# Returns one random avatar for a GUI save slot
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

# Opens a save file, instances it and returns this instance
static func read_save(path):
	var savegame = File.new()
	if !savegame.file_exists(path):
		return {} # We don't have a save to load

	savegame.open(path, File.READ) # FIXME: Open encrypted
	var data = dict2inst(savegame.get_var())
	savegame.close()

	return data

# Writes a save file with given data
static func write_save(path, data):
	var savegame = File.new()

	savegame.open(path, File.WRITE) # FIXME: Open encrypted
	savegame.store_var(inst2dict(data))
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
	Globals.set("Difficulty", difficulty)
	current_slot = SaveSlot.new()
	current_slot.set_scene(initial_scene)
	KHR2.reset_playtime()
	return true

func load_game(slot_idx):
	current_slot = get_save(slot_idx)
	KHR2.reset_playtime(current_slot.get("playtime_min"), current_slot.get("playtime_hrs"))

	emit_signal("loaded")
	return true

func save_game(slot_idx):
	current_slot.update(get_tree().get_current_scene().get_filename(), random_avatar())
	var path = fmt_path(slot_idx)
	write_save(path, current_slot)

	emit_signal("saved")
	return true

func quick_load():
	var path = "user://" + "quick" + SAVE_NAME + "." + SAVE_EXT
	current_slot = read_save(path)
	print("Quick loaded!")

func quick_save():
	var path = "user://" + "quick" + SAVE_NAME + "." + SAVE_EXT
	current_slot.update(get_tree().get_current_scene().get_filename())
	write_save(path, current_slot)
	print("Quick saved!")
