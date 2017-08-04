extends Object

# Classes
const Ability = preload("Abilities/Ability.gd")


# List of all abilities learned by idx = level.
# e.g. Abilities obtained at level 15 are stored in abilities[14] as an Array
# accessible via Level.get(15)
var abilities = []

######################
### Core functions ###
######################
func _init(num_levels=1, new_abilities=[]):
	abilities = new_abilities
	set_maximum_level(num_levels)

func _get(idx):
	return abilities[idx-1] if 0 < idx && idx < abilities.size() else []

# Sets abilities at a given level.
func _set(idx, value):
	idx -= 1 # Correcting index
	var is_array   = typeof(value) == TYPE_ARRAY
	var is_ability = value extends Ability

	if idx < abilities.size():
		if is_array:
			# Only add valid abilities
			for ability in value:
				if ability extends Ability:
					abilities[idx].push_back(ability)
		elif is_ability:
			abilities[idx].push_back(value)
	else:
		print(str(value.name), " was not set: index exceeds maximum level number")

########################
### Helper functions ###
########################
static func is_level(value):
	return typeof(value) == TYPE_INT

###############
### Methods ###
###############
# Level value manipulation
func set_maximum_level(value):
	abilities.resize(max(1, value))

func set_level(value):
	if value == get_level():
		return # do nothing
	set_maximum_level(value)

func get_level():
	return abilities.size()

# Helpers
func level_up():
	set_level(get_level() + 1)

func level_down():
	set_level(get_level() - 1)
