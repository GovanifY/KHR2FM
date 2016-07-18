extends Node2D

# Export values
export(String) var info_message = "INFO_BATTLE_MESSAGE"
export(NodePath) var Player = null
#export(NodePath) var Enemy
#export(int, 0, 20) var enemy_multiplier

# Instance members
onready var InfoBar = get_node("InfoBar")

var BattleState = {
	"battle" : false,
	"qte" : false
}

######################
### Core functions ###
######################
func _ready():
	# Important checks
	assert(Player != null && !Player.is_empty())

	# Node fetching
	Player = get_node(Player)

	# Start Infobar animation
	InfoBar.init()
	InfoBar.connect("dismiss", self, "_battle_begin")
	InfoBar.display(info_message)

	# Démarrer les procès necessaires
	set_process_input(true) # input
	set_process(true)       # frame-by-frame

func _input(event):
	# Input a considérer ssi on est en mode Battle
	if BattleState.battle:
		Player.handle_input(event)

func _process(delta):
	### Actions pour Player ###
	# L'anim de garde ("X"), tout est stoppé lorsqu'on la joue
	if Player.is_guarding():
		Player.do_guard()
		return

	# Si le player doit bouger ou pas
	if Player.is_moving():
		Player.do_move()
	else:
		Player.play_anim("Still")

	### Actions pour les ennemis ###
	# TODO

	### GLOBAL ###
	# Délimitations de la zone
	Player.do_limit_pos()

#######################
### Signal routines ###
#######################
func _battle_begin():
	BattleState.battle = true

###############
### Methods ###
###############
