extends Object

# Classes
const Ability     = preload("Abilities/Ability.gd")
const PlayerStats = preload("Stats/PlayerStats.gd")

# Associated stats object
var stats

# List of all abilities learned by idx = level.
# e.g. Abilities obtained at level 15 are stored in abilities[14] as an Array
# accessible via Level.get(15)
var abilities = []

######################
### Core functions ###
######################
func _init(new_stats, new_abilities=[]):
	if new_stats extends PlayerStats:
		abilities = new_abilities
		stats = new_stats
		set_maximum_level(stats.get("lv"))
	else:
		print("Level: Given constructor argument is not valid")
		free()
		return null

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
	elif value > get_level():
		add_abilities(value)
	else:
		remove_abilities(value)
	stats.set("lv", value)
	set_maximum_level(value)

func get_level():
	return abilities.size()

# Helpers
func level_up():
	set_level(get_level() + 1)

func level_down():
	set_level(get_level() - 1)

# Abilities manipulation
func add_abilities(end):
	for idx in range(get_level(), end):
		for ability in abilities[idx]:
			stats.add_modifier(ability.name, ability)

func remove_abilities(end):
	if get_level() <= end:
		return # Avoid infinite loop
	for idx in range(get_level(), end, -1):
		for ability in abilities[idx]:
			stats.remove_modifier(ability.name)
