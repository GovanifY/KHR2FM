extends Node2D

# Export values
export(String) var info_message = "INFO_BATTLE_MESSAGE"
export(NodePath) var Player = null
export(NodePath) var Enemy = null
#export(int, 0, 20) var enemy_multiplier

# Instance members
onready var InfoBar = get_node("InfoBar")
var Battlers = []

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
		Battlers.push_back(Player)

	# Preparing Enemy
	# TODO: Prepare this setup for multiple, different enemies
	if _is_nodepath(Enemy):
		Enemy = get_node(Enemy)
	if typeof(Enemy) == TYPE_OBJECT && Enemy.is_type("Battler"):
		var EnemyHP = get_node("HUD/EnemyHP")
		Enemy.set_hp_bar(EnemyHP)
		Enemy.set_pos(default_pos[2])
		Battlers.push_back(Enemy)

	translate_commands()
	InfoBar.init()
	init_battle()

#######################
### Signal routines ###
#######################
func _battle_begin():
	# Player gains control
	if typeof(Player) == TYPE_OBJECT && Player.is_type("Battler"):
		Player.set_process_input(true)

	# Animate all Battlers
	for battler in Battlers:
		battler.set_fixed_process(true)

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
# Initializes pre-battle environment. Useful when controlling BattlePlan as a child
func init_battle():
	# Battlers should stand down until further notice
	if typeof(Player) == TYPE_OBJECT && Player.is_type("Battler"):
		# Player not processing input means that this function has already been called
		if !Player.is_processing_input():
			return
		Player.set_process_input(false)
	for battler in Battlers:
		battler.set_fixed_process(false)

	# Start Infobar animation
	if !InfoBar.is_connected("dismiss", self, "_battle_begin"):
		InfoBar.connect("dismiss", self, "_battle_begin")
	InfoBar.display(info_message)

# Force-stop every single animation node from every battler on scene if unspecified
func stop_all_anims(battler = null):
	if battler == null:
		# Iterating all registered Battlers
		for battler in Battlers:
			# Checking if the Battler has a Node named "anims"
			battler.stop_anims()
	else:
		battler.stop_anims()

# (Re)Translate all HUD Command text
func translate_commands():
	var commands = get_node("HUD/Commands")

	var label_attack = commands.find_node("BATTLE_ATTACK")
	if label_attack != null:
		label_attack.set_text(tr("BATTLE_ATTACK"))
