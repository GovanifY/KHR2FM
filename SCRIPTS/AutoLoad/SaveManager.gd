extends Node

################################################################################
# This script serves as a data bank for any and all Save data (including but   #
# not limited to Stats, Inventory, Drives and Trophies).                       #
# This data can be serialized and channeled to Save files.                     #
################################################################################

# Serializable dictionary filled with the most important info for a save file
var save_data = {
	# Switches
	ZeroEXP = false
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

####################
### Main Methods ###
####################
func new_game():
	# TODO: Set the stats for a new game depending on the difficulty and ZeroEXP
	pass

func load_game():
	pass

func save_game():
	pass

####################
###   Modifiers  ###
####################
func get_value(key):
	if !_has_key():
		return
	return save_data[key]

func set_value(key, value):
	if !_has_key():
		return
	save_data[key] = value

# In addition to these above, you can write methods that have more verbose names
# so as to have more legible code when accessing this script.
func get_level():
	return get_value("LV")

func set_level(value):
	set_value("LV", value)
