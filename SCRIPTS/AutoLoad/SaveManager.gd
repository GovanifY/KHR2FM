extends Node

################################################################################
# This script serves as a data bank for any and all Save data (including but   #
# not limited to Stats, Inventory, Drives and Trophies).                       #
# This data can be serialized and channeled to Save files.                     #
################################################################################

# Serializable dictionary filled with the most important info for a save file
var save_data = {
	# IMPORTANT DATA
	Scene = null,

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
	return "user://slot" + String(slot_idx) + ".save"

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

	print("Loaded!")
	print(save_data)

	return true

func save_game(slot_idx):
	var path = fmt_path(slot_idx)
	var savegame = File.new()

	_assemble_data()

	savegame.open(path, File.WRITE)
	savegame.store_var(save_data) # FIXME: It's much more complicated than this
	savegame.close()

	print("Saved!")
	print(save_data)

	return true

func get_save_count():
	return 0 # TODO

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
