extends Node2D

# InfoBar vars
var InfoBar = null

# Player vars
export(String) var player_name = ""
var Player = null

# Enemies vars
# TODO

# Battle vars
var BattleState = {
	"infobar" : false,
	"battle" : false,
	"qte" : false
}

# Core functions
func _input(event):
	# Input a considérer ssi on est en mode Battle
	if BattleState.battle:
		Player.handle_input(event)

func _process(delta):
	### Popup Info checks ###
	if BattleState.infobar:
		InfoBar.display()

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
	# TODO: Éviter valeurs hardcoded comme celles-ci!!!
	Player.do_limit_pos(-222, 620)

func _ready():
	# Initialization des Nodes
	Player = get_node(player_name)
	InfoBar = get_node("InfoBar")

	# Commencer l'animation d'info
	summon_infobar(null)

	# Démarrer les procès necessaires
	set_process_input(true) # input
	set_process(true)       # frame-by-frame


# Battle Methods
func summon_infobar(messageID):
	InfoBar.init(messageID)
	BattleState.infobar = true
	InfoBar.connect("dismiss", self, "_dismiss_infobar")

func _dismiss_infobar():
	BattleState.infobar = false
	BattleState.battle = true
