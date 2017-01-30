extends "res://SCRIPTS/Battle/Battler.gd"


######################
### Core functions ###
######################
func _ready():
	add_to_group(.get_type())
	add_to_group(get_type())

###############
### Methods ###
###############
### Overloading functions
func get_type():
	return "BattleEnemy"

func is_type(type):
	return type == get_type()
