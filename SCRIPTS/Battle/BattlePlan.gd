extends Node

# Export values
export(AudioStream) var battle_music
export(int, 1, 20) var enemy_instances = 1
export(bool) var random_instances = false

# Constants
const PATH_HUD = "res://SCENES/Battle/HUD/HUD.tscn"

# Instance members
onready var HUD = KHR2.get_node("HUD")

######################
### Core functions ###
######################
func _enter_tree():
	SceneLoader.load_scene(PATH_HUD, SceneLoader.BACKGROUND)
	SceneLoader.show_scene(PATH_HUD)

func _exit_tree():
	SceneLoader.erase_scene(HUD)

func _ready():
	# Preparing music
	if battle_music != null:
		# If the tracks are different, swap with the new one
		if (Music.get_stream_name() != battle_music.get_name()):
			Music.set_stream(battle_music)
			Music.play()

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

	# Setting all battlers' Y position (they must stand down before further instructions)
	var middle = int(OS.get_video_mode_size().y) >> 1
	get_tree().call_group(SceneTree.GROUP_CALL_DEFAULT, "Battler", "set_y", middle)

	start()

###############
### Methods ###
###############
func start():
	get_tree().call_group(SceneTree.GROUP_CALL_DEFAULT, "Battler", "fight")

func stop():
	get_tree().call_group(SceneTree.GROUP_CALL_DEFAULT, "Battler", "at_ease")
