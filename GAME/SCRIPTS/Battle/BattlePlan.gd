extends Node2D

# Export values
export(String) var info_message = "INFO_BATTLE_MESSAGE"
export(NodePath) var Player = null
export(NodePath) var Enemy = null
#export(int, 0, 20) var enemy_multiplier

# Instance members
onready var InfoBar = get_node("InfoBar")

######################
### Core functions ###
######################
func _ready():
	# Default positions for the main Battlers
	var default_pos = _get_default_pos()

	# Preparing Player
	if _is_nodepath(Player):
		Player = get_node(Player)
	if typeof(Player) == TYPE_OBJECT && Player.is_type("Battler"):
		Player.set_pos(default_pos[0])

	# Preparing Enemy
	# TODO: Prepare this setup for multiple, different enemies
	if _is_nodepath(Enemy):
		Enemy = get_node(Enemy)
	if typeof(Enemy) == TYPE_OBJECT && Enemy.is_type("Battler"):
		var EnemyHP = get_node("HUD/EnemyHP")
		Enemy.set_hp_bar(EnemyHP)
		Enemy.set_pos(default_pos[2])

	translate_commands()
	init_battle()

#######################
### Signal routines ###
#######################
func _battle_begin():
	get_tree().call_group(0, "Battlers", "fight")

########################
### Helper functions ###
########################
# Checks if the given argument is a valid NodePath
static func _is_nodepath(nodepath):
	return typeof(nodepath) == TYPE_NODE_PATH && !nodepath.is_empty()

# Updates the default positions to put our Battlers divided in 3 (left, center, right)
static func _get_default_pos():
	var default_pos = Vector2Array()
	default_pos.resize(3)
	default_pos[0] = OS.get_video_mode_size()

	# Adjusting Y (Height)
	default_pos[0].y = int(default_pos[0].y) >> 1
	default_pos[1] = default_pos[0]
	default_pos[2] = default_pos[0]

	# Adjusting X (Length)
	default_pos[1].x = int(default_pos[1].x) >> 1
	default_pos[0].x = int(default_pos[0].x) >> 3
	default_pos[2].x -= default_pos[0].x

	return default_pos

###############
### Methods ###
###############
# Initializes pre-battle environment
func init_battle():
	# InfoBar processing input means that this function has already been called
	if InfoBar.is_processing_input():
		return
	# Battlers should stand down until further notice
	get_tree().call_group(0, "Battlers", "at_ease")

	# Start Infobar animation
	InfoBar.display(info_message)

# (Re)Translate all HUD Command text
func translate_commands():
	var commands = get_node("HUD/Commands")

	var label_attack = commands.find_node("BATTLE_ATTACK")
	if label_attack != null:
		label_attack.set_text(tr("BATTLE_ATTACK"))
