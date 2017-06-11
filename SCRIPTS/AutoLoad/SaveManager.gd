extends Node

################################################################################
# This script serves as a data bank for any and all Save data (including but   #
# not limited to Stats, Inventory, Drives and Trophies).                       #
# This data can be serialized and channeled to Save files.                     #
################################################################################

const SAVE_NAME = "slot"
const SAVE_EXT  = "save"

# Serializable dictionary filled with the most important info for a save file
var save_data = {
	# IMPORTANT DATA
	Scene = null,
	Location = null,

	# Switches
	ZeroEXP = false,
	# Basic stats
	LV = 1,
	HP = 10,
	Attack = 1,
	Defense = 1,
	# Stat adders
	Keyblade = "",
	# TODO: Items, magic, abilities, limits
}

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
	save_data.Scene = get_tree().get_current_scene().get_filename()
	# TODO: Do rest of the save data

########################
### Helper functions ###
########################
static func fmt_path(slot_idx):
	return "user://" + SAVE_NAME + String(slot_idx) + "." + SAVE_EXT

static func is_save_file(filename):
	return filename.begins_with(SAVE_NAME) && filename.extension() == SAVE_EXT

####################
### Main Methods ###
####################
func new_game():
	# TODO: Set the stats for a new game depending on the difficulty and ZeroEXP
	return false

func load_game(slot_idx):
	var path = fmt_path(slot_idx)
	var savegame = File.new()
	if !savegame.file_exists(path):
		return false # We don't have a save to load

	savegame.open(path, File.READ)
	save_data = savegame.get_var() # FIXME: It's much more complicated than this

	return true

func save_game(slot_idx):
	var path = fmt_path(slot_idx)
	var savegame = File.new()

	_assemble_data()

	savegame.open(path, File.WRITE)
	savegame.store_var(save_data) # FIXME: It's much more complicated than this
	savegame.close()

	return true

func get_save_count():
	var dir = Directory.new()
	if dir.open("user://") != OK:
		return -1

	var counter = 0

	dir.list_dir_begin()
	var filename = dir.get_next()
	while (filename != ""):
		if !dir.current_is_dir() && is_save_file(filename):
			counter += 1
		filename = dir.get_next()

	return counter

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
func get_level(): return get_value("LV")
func set_level(value):   set_value("LV", value)

func get_scene(): return get_value("Scene")
func set_scene(value):   set_value("Scene", value)
