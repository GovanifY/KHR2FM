extends Node2D

# Export values
export(NodePath) var Player = null
export(String) var info_message = "BATTLE INFO MESSAGE"

# Instance members
var InfoBar = null

var BattleState = {
	"battle" : false,
	"qte" : false
}

######################
### Core functions ###
######################
func _ready():
	# Nodes initialization
	Player = get_node(Player)
	InfoBar = get_node("InfoBar")

	# Start Infobar animation
	InfoBar.init()
	InfoBar.connect("dismiss", self, "_dismiss_infobar")
	summon_infobar(info_message)

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
func _dismiss_infobar():
	BattleState.battle = true

###############
### Methods ###
###############
func summon_infobar(messageID):
	InfoBar.display(messageID)
