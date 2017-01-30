extends Node

# Export values
export(int, 1, 20) var enemy_instances = 1
export(bool) var random_instances = false

# Instance members

######################
### Core functions ###
######################
func _enter_tree():
	if Globals.get("BattlePlan") != null:
		print("One BattlePlan node is already enough!")
		queue_free()
	else:
		Globals.set("BattlePlan", get_path())

func _exit_tree():
	Globals.set("BattlePlan", null)

func _ready():
	# Preparing Enemies
	enemy_instances -= 1 # Don't count the already avaliable instance
	if enemy_instances > 0:
		# Grab all enemies picked for this battle
		var all_enemies = get_tree().get_nodes_in_group("Enemy")
		for enemy in all_enemies:
			# Use RNG if requested; otherwise, use the exact number requested
			var rng = randi() % enemy_instances if random_instances else enemy_instances
			for i in range(rng):
				var new_enemy = enemy.duplicate()
				enemy.get_parent().call_deferred("add_child", new_enemy)

				# Fixing positions
				# TODO: fix new_enemy node's positions so they don't stack on one another

	# Preparing all battlers (they must stand down before further instructions)
	var middle = int(OS.get_video_mode_size().y) >> 1
	get_tree().call_group(SceneTree.GROUP_CALL_DEFAULT, "Battler", "set_y", middle)

	_battle_begin()

#######################
### Signal routines ###
#######################
func _battle_begin():
	get_tree().call_group(SceneTree.GROUP_CALL_DEFAULT, "Battler", "fight")

func _battle_halt():
	get_tree().call_group(SceneTree.GROUP_CALL_DEFAULT, "Battler", "at_ease")

###############
### Methods ###
###############
