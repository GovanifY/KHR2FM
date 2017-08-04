extends Object

# Classes
const Ability = preload("Abilities/Ability.gd")

# List of all abilities learned by idx = level.
# e.g. Abilities obtained at level 15 are stored in abilities[15] as an Array
var abilities = []

######################
### Core functions ###
######################
func _init(levels=1):
	abilities.resize(levels)

func _get(idx):
	return abilities[idx] if abilities.size() > idx else null

# Sets abilities at a given level.
func _set(idx, value):
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
		print(str(value.name), " was not set: index exceeds maximum levels")

########################
### Helper functions ###
########################
static func is_level(value):
	return typeof(value) == TYPE_INT

###############
### Methods ###
###############
func get_abilities_up_to(value):
	value = min(value, abilities.size())
	var list = []
	for idx in range(value):
		list += abilities[idx] if abilities[idx] != null else []
	return list

func set_maximum_level(value):
	abilities.resize(value)
