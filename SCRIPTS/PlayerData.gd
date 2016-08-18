extends Node

################################################################################
# This script serves as a data bank for all the Player's data (Stats,          #
# Inventory, Drives, Trophies and whatnot).                                    #
# This data can be serialized and channeled to the Save/Load script.           #
################################################################################

######################
### Core functions ###
######################
func _exit_tree():
	# TODO: Save data to a file?
	pass

###############
### Methods ###
###############
# Getters
func get_stats():
	pass

func get_items():
	pass

func get_trophies():
	pass

func get_drives():
	pass
