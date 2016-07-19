extends Node2D

# Export values
export(String) var info_message = "INFO_BATTLE_MESSAGE"
export(NodePath) var Player = null
#export(NodePath) var Enemy
#export(int, 0, 20) var enemy_multiplier

# Instance members
onready var InfoBar = get_node("InfoBar")

######################
### Core functions ###
######################
func _ready():
	# Important checks
	assert(Player != null && !Player.is_empty())

	# Preparing Player
	Player = get_node(Player)
	Player.set_process_input(false)

	init_battle()

#######################
### Signal routines ###
#######################
func _battle_begin():
	Player.set_process_input(true)

###############
### Methods ###
###############
# Initializes pre-battle environment. Useful when controlling BattlePlan as a child
func init_battle():
	# Start Infobar animation
	InfoBar.init()
	InfoBar.connect("dismiss", self, "_battle_begin")
	InfoBar.display(info_message)
