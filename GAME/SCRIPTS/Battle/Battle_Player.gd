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
	# Nodes
	"anims"  : null,     # Node type "Node" qui ne contient QUE DES "AnimationPlayer"
	"sprite" : null      # Node type "Sprite"
}

# Status des actions du Player
var Status = {
	"direction" : "",     # String qui se colle à la fin de chaque nom d'anim
	"action"    : null,   # L'animation qui cours (Still, Walk...)
	"guard"     : false,  # Boolean pour commencer l'action "Guard"
	"guarding"  : false,  # Est-on protégé des attaques?
	"moving"    : false   # Boolean qui indique si le player bouge
}

######################
### Core functions ###
######################
func _ready():
	# Initialization du Player
	Data.name = get_name()
	Data.speed = player_speed
	Data.anims = get_node("anims")
	Data.sprite = get_node(Data.name + "_Sprite")

	# Connection de "signals" pour Guard
	for anim in Data.anims.get_children():
		if (anim.get_name() == Data.name + "_Guard_Left" ||
			anim.get_name() == Data.name + "_Guard_Right"):
			anim.connect("finished", self, "_end_guard")

	# Direction par défaut
	Status.direction = "Right"

#######################
### Signal routines ###
#######################
func _end_guard():
	Status.guarding = false
	Status.guard = false

###############
### Methods ###
###############
## Input
func handle_input(event):
	# Pressed, non-repeating Input check (for very specific actions)
	if event.is_pressed() && !event.is_echo():
		if !Status.guarding:
			Status.guard = event.is_action("cancel")

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

## is_ functions
func is_moving():
	return Status.moving

func is_guarding():
	return Status.guard || Status.guarding

## Actions
func do_limit_pos():
	if (get_pos().x <= limit_left):
		set_pos(Vector2(limit_left, get_pos().y))
	if (get_pos().x >= limit_right):
		set_pos(Vector2(limit_right, get_pos().y))

func do_move():
	var mod = 1
	if Status.direction == "Left": mod = -1

	var distance = Data.speed * mod
	play_anim("Walk")
	set_pos(Vector2(get_pos().x + distance, get_pos().y))

func do_guard():
	if !Status.guarding:
		play_anim("Guard")
		Status.guarding = true

## Réglage des animations
func stop_all_anims():
	# Chercher tous les Nodes d'animation
	var all_anims = Data.anims.get_children()
	for anim in all_anims:
		anim.stop()

func play_anim(action_name):
	var anim_name = Data.name + "_" + action_name + "_" + Status.direction
	var anim_node = Data.anims.get_node(anim_name)

	if (!anim_node.is_playing()):
		if Status.action != null:
			Status.action.stop()
		Status.action = anim_node
		Status.action.play(anim_name)
