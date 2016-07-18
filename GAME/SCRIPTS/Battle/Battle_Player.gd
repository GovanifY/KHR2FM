extends Control

# Export values
export(int, 1, 20) var player_speed = 5
export(int) var limit_left = 0
export(int) var limit_right = 877

# Données importantes sur le player
var Data = {
	# Valeurs variées
	"name"   : "",       # Nom du personnage
	"speed"  : 0,        # Vitesse (en pixels)
	"height" : 0,
	# Nodes
	"anims"  : null,     # Node type "Node" qui ne contient QUE DES "AnimationPlayer"
	"sprite" : null      # Node type "Sprite"
}

# Status des actions du Player
var Status = {
	"direction" : "",     # String qui s'ajoute à la fin de chaque nom d'anim
	"action"    : null,   # L'animation executée (Still, Walk...)
	"guard"     : false,  # Boolean pour commencer l'action "Guard"
	"guarding"  : false,  # Est-on protégé des attaques?
	"moving"    : false,  # Boolean qui indique si le joueur bouge
	"attack"	: 0,      # Integer qui défini l'attaque actuelle
	"hit"		: false   # Boolean qui défini si le joueur attaque
}

######################
### Core functions ###
######################
func _ready():
	# Initialization du Player
	Data.name = get_name()
	Data.speed = player_speed
	Data.height = get_pos().y
	Data.anims = get_node("anims")
	Data.sprite = get_node(Data.name + "_Sprite")

	# Connection de "signals" pour Guard
	for anim in Data.anims.get_children():
		if (anim.get_name() == Data.name + "_Guard_Left" ||
			anim.get_name() == Data.name + "_Guard_Right"):
			anim.connect("finished", self, "_end_guard")

	for anim in Data.anims.get_children():
		for i in range(1,4):
			if (anim.get_name() == Data.name + "_Attack" + str(i) + "_Left" ||
				anim.get_name() == Data.name + "_Attack" + str(i) + "_Right"):
				anim.connect("finished", self, "_end_attack")
	# Direction par défaut
	Status.direction = "Right"

## is_ functions
func _is_moving():
	return Status.moving

func _is_guarding():
	return Status.guard || Status.guarding

func _is_attacking():
	return Status.attack || Status.hit

## do_ functions
func _do_move():
	var mod = 1
	if Status.direction == "Left": mod = -1

	var distance = Data.speed * mod
	play_anim("Walk")
	set_pos(Vector2(get_pos().x + distance, Data.height))

func _do_guard():
	if !Status.guarding:
		play_anim("Guard")
		Status.guarding = true

func _do_attack():
	if !Status.hit:
		play_anim("Attack" + str(Status.attack))
		Status.hit = true

#######################
### Signal routines ###
#######################
func _end_guard():
	Status.guarding = false
	Status.guard = false

func _end_attack():
	Status.attack = 0
	Status.hit = false

###############
### Methods ###
###############
## Input
func handle_input(event):
	# Pressed, non-repeating Input check (for very specific actions)
	if event.is_pressed() && !event.is_echo():
		if !Status.guarding:
			Status.guard = event.is_action("cancel")
		if !Status.hit && Status.attack < 3 && event.is_action("enter"):
			Status.attack = Status.attack+1

	# Simple Input check
	var left    = Input.is_action_pressed("ui_left")
	var right   = Input.is_action_pressed("ui_right")
	var confirm = Input.is_action_pressed("enter")

	# déterminer la priorité de direction
	if left && right:
		left  = (Status.direction == "Left")
		right = !left

	# Indiquer la direction finale
	if left:
		Status.direction = "Left"
		Status.moving    = true
	elif right:
		Status.direction = "Right"
		Status.moving    = true
	else:
		Status.moving    = false

## Actions
func do_actions():
	# L'anim de garde ("X"), tout est stoppé lorsqu'on la joue
	if _is_guarding():
		_do_guard()
		return
	# L'anim' d'attaque("C"), idem
	if _is_attacking():
		_do_attack()
		return

	# Si le player doit bouger ou pas
	if _is_moving():
		_do_move()
	else:
		play_anim("Still")

func do_limit_pos():
	if (get_pos().x <= limit_left):
		set_pos(Vector2(limit_left, Data.height))
	if (get_pos().x >= limit_right):
		set_pos(Vector2(limit_right, Data.height))

## Réglage des animations
func stop_all_anims():
	# Chercher tous les Nodes d'animation
	var all_anims = Data.anims.get_children()
	for anim in all_anims:
		anim.stop()

func play_anim(action_name):
	var anim_name = Data.name + "_" + action_name + "_" + Status.direction
	var anim_node = Data.anims.get_node(anim_name)

	if !anim_node.is_playing():
		if Status.action != null:
			Status.action.stop()
		Status.action = anim_node
		Status.action.play(anim_name)
