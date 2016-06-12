extends Node2D

# Export values
export(String) var player_name
export(int, 1, 20) var player_speed = 5

# Player vars
var PlayerStats = {
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
	# actions
	"guard" : false,    # Boolean pour commencer l'action "Guard"
	"guarding" : false, # Boolean pour savoir si l'on est protégé des attaques
	"moving" : false,   # Boolean qui indique si le player bouge
	# input
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
		PlayerControl.confirm = Input.is_action_pressed("enter")
		PlayerControl.cancel = Input.is_action_pressed("cancel")

		### PlayerControl.moving ###
		# déterminer la priorité de direction
		if PlayerControl.left && PlayerControl.right:
			PlayerControl.left = (PlayerStats.direction == "Left")
			PlayerControl.right = !PlayerControl.left
		# Indiquer la direction finale
		if PlayerControl.left:
			PlayerStats.direction = "Left"
			PlayerControl.moving = true
		elif PlayerControl.right:
			PlayerStats.direction = "Right"
			PlayerControl.moving = true
		else:
			PlayerControl.moving = false

		### PlayerControl.guarding ###
		if PlayerControl.cancel && !PlayerControl.guard:
			PlayerControl.guard = true
		elif event.is_action_released("cancel"):
			PlayerControl.guard = false

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
	if PlayerControl.moving && !PlayerControl.guarding:
		var mod
		if PlayerStats.direction == "Left": mod = -1
		else: mod = 1

		var speed = PlayerStats.speed * mod
		Player_play_anim("Walk")
		PlayerStats.sprite.set_pos(Vector2(PlayerStats.sprite.get_pos().x + speed, PlayerStats.sprite.get_pos().y))

	# L'anim de garde ("X"), tout est stoppé lorsqu'on la joue
	if PlayerControl.guard || PlayerControl.guarding:
		if !PlayerControl.guarding:
			Player_play_anim("Guard")
			PlayerControl.guarding = true
		elif !Player_is_anim_playing("Guard"):
			PlayerControl.guarding = false

	# L'anim 'still'
	if !PlayerControl.moving && !PlayerControl.guarding:
		Player_play_anim("Still")

	# Délimitations de la zone
	# TODO: Éviter valeurs hardcoded comme celles-ci!!!
	if (PlayerStats.sprite.get_pos().x <= -222):
		PlayerStats.sprite.set_pos(Vector2(-222, PlayerStats.sprite.get_pos().y))
	if (PlayerStats.sprite.get_pos().x >= 620):
		PlayerStats.sprite.set_pos(Vector2(620, PlayerStats.sprite.get_pos().y))

func _ready():
	# Export des valeurs
	PlayerStats.name = player_name
	PlayerStats.speed = player_speed

	# Initialization du Player
	PlayerStats.direction = "Right"
	PlayerStats.node = get_node(PlayerStats.name)
	PlayerStats.anims = PlayerStats.node.get_node("anims")
	PlayerStats.sprite = PlayerStats.node.get_node(PlayerStats.name + "_Sprite")
	# Remettre "root" des animations pour qu'elles communiquent avec le Sprite
	for anim in PlayerStats.anims.get_children():
		anim.set_root("../..")

	# Commencer l'animation d'info
	init_info_popup()

	# Démarrer les proces necessaires
	set_process_input(true) # input
	set_process(true)       # frame-by-frame


# Battle Methods
func init_info_popup():
	BattleState.info_popup = true
	BattleState.battle = false
	get_node("Info_Popup").play("Info_Popup")

## Paramétrisation d'Animations
func Player_stop_all_anims():
	# Chercher tous les Nodes d'animation
	var all_anims = PlayerStats.anims.get_children()
	for anim in all_anims:
		anim.stop()

func Player_play_anim(action_name):
	var anim_name = PlayerStats.name + "_" + action_name + "_" + PlayerStats.direction
	var anim_node = PlayerStats.anims.get_node(anim_name)

	if (!anim_node.is_playing()):
		if PlayerStats.action != null:
			PlayerStats.action.stop()
		PlayerStats.action = anim_node
		PlayerStats.action.play(anim_name)

func Player_is_anim_playing(action_name):
	var anim_name = PlayerStats.name + "_" + action_name + "_" + PlayerStats.direction
	var anim_node = PlayerStats.anims.get_node(anim_name)
	return anim_node.is_playing()
