extends Node2D

# Export values
export(String) var info_message = "INFO_BATTLE_MESSAGE"
export(NodePath) var Player = null
export(NodePath) var Enemy = null
#export(int, 0, 20) var enemy_multiplier

# Instance members
onready var InfoBar = get_node("InfoBar")
var DefaultPos = Vector2Array()  # Vector2Array of size 3 (left, center, right)
var Battlers = []

######################
### Core functions ###
######################
func _ready():
	# New positions for the main Battlers
	update_positions()

	# Preparing Player
	if _is_nodepath(Player):
		Player = get_node(Player)
	if _is_battler(Player):
		Player.set_process_input(false)
		Player.set_pos(Vector2(DefaultPos[0]))
		Battlers.push_back(Player)

	# Preparing Enemy
	# TODO: This setup is currently for one-boss only. Prepare it for multiple, different enemies
	if _is_nodepath(Player):
		Enemy = get_node(Enemy)
	if _is_battler(Enemy):
		#Enemy.init_hp_or_something()
		Enemy.set_pos(Vector2(DefaultPos[2]))
		Battlers.push_back(Enemy)

	# Battlers should stand down until further notice
	for battler in Battlers:
		battler.set_fixed_process(false)

	init_battle()

#######################
### Signal routines ###
#######################
func _battle_begin():
	# Player gains control
	if _is_battler(Player):
		Player.set_process_input(true)

	# All Battlers
	for battler in Battlers:
		battler.set_fixed_process(true)

########################
### Helper functions ###
########################
# Checks if the given argument is a valid NodePath
static func _is_nodepath(nodepath):
	return typeof(nodepath) == TYPE_NODE_PATH && !nodepath.is_empty()

# Checks if the given argument is a Battler Node
static func _is_battler(node):
	return (
		typeof(node) == TYPE_OBJECT && node.is_type("KinematicBody2D")
		#&& node.get_script() != null && node.get_script().has_source_code()
	)

###############
### Methods ###
###############
# Updates the default positions to put our Battlers
func update_positions():
	DefaultPos.resize(3)
	DefaultPos[0] = OS.get_video_mode_size()

	# Adjusting Y (Height)
	DefaultPos[0].y = int(DefaultPos[0].y) >> 1
	DefaultPos[1] = DefaultPos[0]
	DefaultPos[2] = DefaultPos[0]

	# Adjusting X (Length)
	DefaultPos[1].x = int(DefaultPos[1].x) >> 1
	DefaultPos[0].x = int(DefaultPos[0].x) >> 3
	DefaultPos[2].x -= DefaultPos[0].x

# Initializes pre-battle environment. Useful when controlling BattlePlan as a child
func init_battle():
	# Start Infobar animation
	InfoBar.init()
	InfoBar.connect("dismiss", self, "_battle_begin")
	InfoBar.display(info_message)

# Force-stop every single animation node in an Array
func stop_anims(anim_nodes):
	if typeof(anim_nodes) == TYPE_OBJECT && anim_nodes.is_type("Node"):
		anim_nodes = anim_nodes.get_children()

	# If we got our array correctly
	if typeof(anim_nodes) == TYPE_ARRAY:
		for anim in anim_nodes:
			if typeof(anim) == TYPE_OBJECT && anim.is_type("AnimationPlayer"):
				anim.stop()
