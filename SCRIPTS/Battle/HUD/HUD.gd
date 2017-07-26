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

func reset_hud(parent, member):
	for node in parent.get_children():
		# If we cannot change its value, ignore it
		if !node.has_method("set_value"):
			continue

		var name = node.get_name().to_lower()
		member[name] = node

func set_stats(member, stats):
	# Iterate the member's dictionary of ProgressBars/GUI nodes
	for key in member:
		# If it exists in stats, set its value
		if key in stats.final:
			member[key].set_value(stats.get(key))

func set_player_stats(stats):
	set_stats(player, stats)

func set_enemy_stats(stats):
	set_stats(enemy, stats)
