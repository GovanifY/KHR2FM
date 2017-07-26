extends Control

# Instance members
onready var commands = get_node("Commands")

onready var player = {
	"mp" : get_node("Player/MP"),
}

onready var enemy = {
	"mp" : get_node("Enemy/HP"),
}


###############
### Methods ###
###############
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
