extends Node2D

# Export values
export(String) var info_message = "INFO_BATTLE_MESSAGE"
export(NodePath) var Player = null
#export(NodePath) var Enemy
#export(int, 0, 20) var enemy_multiplier

# Instance members
onready var InfoBar = get_node("InfoBar")
var Battlers = []

######################
### Core functions ###
######################
func _ready():
	# Preparing Player
	if _is_nodepath(Player):
		Player = get_node(Player)
		if _is_battler(Player):
			Player.set_process_input(false)
			Battlers.push_back(Player)

	# Battlers should stand down until further notice
	for battler in Battlers:
		battler.set_fixed_process(false)

	init_battle()

#######################
### Signal routines ###
#######################
func _battle_begin():
	# Player gains control
	Player.set_process_input(true)

	# All Battlers
	for battler in Battlers:
		battler.set_fixed_process(true)

########################
### Helper functions ###
########################
# Checks if the given argument is a valid NodePath
static func _is_nodepath(nodepath):
	return (nodepath != null
		&& typeof(nodepath) == TYPE_NODE_PATH && !nodepath.is_empty()
	)

# Checks if the given argument is a Battler Node
static func _is_battler(node):
	return (node != null
		&& typeof(node) == TYPE_OBJECT && node.is_type("KinematicBody2D")
		#&& node.get_script() != null && node.get_script().has_source_code()
	)

###############
### Methods ###
###############
# Initializes pre-battle environment. Useful when controlling BattlePlan as a child
func init_battle():
	# Start Infobar animation
	InfoBar.init()
	InfoBar.connect("dismiss", self, "_battle_begin")
	InfoBar.display(info_message)
