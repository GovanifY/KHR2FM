extends Node2D

# Export values
export(String) var player_name
export(int, 1, 20) var player_speed = 5

# Player vars
var Player = {
	# Valeurs variees
	"name" : "",        # Nom du personnage
	"speed" : 0,        # Vitesse (en pixels)
	"direction" : "",   # String qui se colle à la fin de chaque nom d'anim
	"action" : null,    # L'animation qui cours (Still, Walk...)
	# Nodes
	"node" : null,      # Node type "Control" du Player principal
	"anims" : null,     # Node type "Control" qui ne contient QUE DES "AnimationPlayer"
	"sprite" : null     # Node type "Sprite"
}

var PlayerControl = {
	"guarding" : false, # Boolean pour savoir si l'on est protégé des attaques
	"moving" : false,   # Boolean qui indique si le player bouge
	"left" : false,
	"right" : false,
	"confirm" : false,
	"cancel" : false
}

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
		# Check d'input
		PlayerControl.left = Input.is_action_pressed("ui_left")
		PlayerControl.right = Input.is_action_pressed("ui_right")

		### Player.moving ###
		# déterminer la priorité de direction
		if PlayerControl.left && PlayerControl.right:
			PlayerControl.left = (Player.direction == "Left")
			PlayerControl.right = !PlayerControl.left
		# Indiquer la direction finale
		if PlayerControl.left && !PlayerControl.guarding:
			Player.direction = "Left"
			PlayerControl.moving = true
		elif PlayerControl.right && !PlayerControl.guarding:
			Player.direction = "Right"
			PlayerControl.moving = true
		else:
			PlayerControl.moving = false

		### Player.guarding ###
		# TODO

func _process(delta):
	# Popup Info checks
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

	# Battle
	# TODO

	# Si le player doit bouger
	if PlayerControl.moving:
		var mod
		if Player.direction == "Left": mod = -1
		else: mod = 1

		var speed = Player.speed * mod
		play_player_anim("Walk")
		Player.sprite.set_pos(Vector2(Player.sprite.get_pos().x + speed, Player.sprite.get_pos().y))

	# L'anim 'still'
	if !PlayerControl.moving && !PlayerControl.guarding:
		play_player_anim("Still")

	# Délimitations de la zone
	# TODO: Éviter valeurs hardcoded comme celles-ci!!!
	if (Player.sprite.get_pos().x <= -222):
		Player.sprite.set_pos(Vector2(-222, Player.sprite.get_pos().y))
	if (Player.sprite.get_pos().x >= 620):
		Player.sprite.set_pos(Vector2(620, Player.sprite.get_pos().y))

func _ready():
	# Export des valeurs
	Player.name = player_name
	Player.speed = player_speed

	# Initialization du Player
	Player.direction = "Right"
	Player.node = get_node(Player.name)
	Player.anims = Player.node.get_node("anims")
	Player.sprite = Player.node.get_node(Player.name + "_Sprite")
	# Remettre "root" des animations pour qu'elles communiquent avec le Sprite
	for anim in Player.anims.get_children():
		anim.set_root("../..")

	# Commencer l'animation d'info
	init_info_popup()

	# Démarrer les proces necessaires
	set_process_input(true) # input
	set_process(true)       # frame-by-frame


# Battle Methods
func stop_all_player_anims():
	# Chercher tous les Nodes d'animation
	var all_anims = Player.anims.get_children()
	for anim in all_anims:
		anim.stop()

func init_info_popup():
	BattleState.info_popup = true
	BattleState.battle = false
	get_node("Info_Popup").play("Info_Popup")

func play_player_anim(action_name):
	var anim_name = Player.name + "_" + action_name + "_" + Player.direction
	var anim_node = Player.anims.get_node(anim_name)

	if (!anim_node.is_playing()):
		if Player.action != null:
			Player.action.stop()
		Player.action = anim_node
		Player.action.play(anim_name)
