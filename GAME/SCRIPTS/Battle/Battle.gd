extends Node2D

# Player vars
export(String) var player_name = ""
var Player = null

# Enemies vars
# TODO

# Battle vars
var BattleState = {
	"info_popup" : false,
	"info_scroll" : false,
	"battle" : false
}

# Core functions
func _input(event):
	# Input a considérer ssi on est en mode Battle
	if BattleState.battle:
		Player.handle_input(event)

func _process(delta):
	### Popup Info checks ###
	if BattleState.info_popup:
		if !BattleState.info_scroll:
			# Si la barre d'info est sur l'écran
			if !get_node("Info_Popup").is_playing():
				# TODO: remove hardcoded values
				get_node("/root/global").textscroll(get_node("Info_Label"), tr("INTRO_INFO_YUUGURE"), null, null)
				BattleState.info_scroll = true
		else:
			# Si le jouer a appuyé pour continuer, retirer la barre
			if !Globals.get("TextScrolling"):
				get_node("Info_Unpop").play("Info_Unpop")
				BattleState.info_popup = false
				BattleState.battle = true

	### Actions pour Player ###
	# L'anim de garde ("X"), tout est stoppé lorsqu'on la joue
	if Player.is_guarding():
		Player.do_guard()
	else:
		# Si le player doit bouger
		if Player.is_moving():
			Player.do_move()
		# L'anim 'still'
		else:
			Player.play_anim("Still")

	# Délimitations de la zone
	# TODO: Éviter valeurs hardcoded comme celles-ci!!!
	Player.do_limit_pos(-222, 620)

	### Actions pour les ennemies ###
	# TODO

func _ready():
	# Export des valeurs
	Player = get_node(player_name)

	# Commencer l'animation d'info
	Info_Popup_init()

	# Démarrer les procès necessaires
	set_process_input(true) # input
	set_process(true)       # frame-by-frame


# Battle Methods
func Info_Popup_init():
	BattleState.info_popup = true
	BattleState.battle = false
	get_node("Info_Popup").play("Info_Popup")
