extends Control


# Instance members
onready var commands = get_node("Commands")

var player = {}
var enemy = {}

###############
### Methods ###
###############
func _ready():
	# Automagically set up node references
	reset_hud(get_node("Player"), player)
	reset_hud(get_node("Enemy"), enemy)

###############
### Methods ###
###############
# Reset HUD connections
func reset_hud(parent, member):
	for node in parent.get_children():
		# If we cannot change its value, ignore it
		if !node.has_method("set_value"):
			continue

		node.set_block_signals(true)
		var name = node.get_name().to_lower()
		member[name] = node

# Sets given stat values for a given member
func set_stats(member, stats):
	stats.connect("value_changed", self, "apply_value", [member])

	# Iterate the member's dictionary of ProgressBars/GUI nodes
	for key in member:
		# If it exists in stats, set its value
		if key in stats.final:
			member[key].set_value(stats.get(key))

# Sets given stat values for the player
func set_player_stats(stats):
	set_stats(player, stats)

# Sets given stat values for the enemy
func set_enemy_stats(stats):
	set_stats(enemy, stats)

# Applies given value to specific stat of a given member
# e.g. player["hp"].set_value(50)
func apply_value(key, value, member):
	member[key].set_value(value)
