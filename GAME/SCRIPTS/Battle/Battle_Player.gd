extends Control

# Export values
export(int, 1, 20) var player_speed = 5

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
	"guarding"  : false,  # Boolean pour savoir si l'on est protégé des attaques
	"moving"    : false   # Boolean qui indique si le player bouge
}

# Contrôle d'input
var Control = {
	"left"    : false,
	"right"   : false,
	"confirm" : false,
	"cancel"  : false
}

# Core functions
func _ready():
	# Export des valeurs
	Data.name = get_name()
	Data.speed = player_speed

	# Initialization du Player
	Status.direction = "Right"
	Data.anims = get_node("anims")
	Data.sprite = get_node(Data.name + "_Sprite")
	# Remettre "root" des animations pour qu'elles communiquent avec le Sprite
	for anim in Data.anims.get_children():
		anim.set_root("../..")

# Input
func handle_input(event):
# Cette fonction ne fait que des changements de variables. Faire autrement implique
# des perdes de performance
	# Check d'input
	Control.left    = Input.is_action_pressed("ui_left")
	Control.right   = Input.is_action_pressed("ui_right")
	Control.confirm = Input.is_action_pressed("enter")
	Control.cancel  = Input.is_action_pressed("cancel")

	### Status.moving ###
	# déterminer la priorité de direction
	if Control.left && Control.right:
		Control.left  = (Status.direction == "Left")
		Control.right = !Control.left
	# Indiquer la direction finale
	if Control.left:
		Status.direction = "Left"
		Status.moving    = true
	elif Control.right:
		Status.direction = "Right"
		Status.moving    = true
	else:
		Status.moving    = false

	### Status.guarding ###
	if Control.cancel && !Status.guard:
		Status.guard = true
	elif event.is_action_released("cancel"):
		Status.guard = false

## get_ & set_ functions
func get_pos():
	return Data.sprite.get_pos()

func set_pos(vec):
	Data.sprite.set_pos(vec)

## is_ functions
func is_moving():
	return Status.moving

func is_guarding():
	return Status.guard || Status.guarding

## Actions
func do_limit_pos(x_left, x_right):
	if (get_pos().x <= x_left):
		set_pos(Vector2(x_left, get_pos().y))
	if (get_pos().x >= x_right):
		set_pos(Vector2(x_right, get_pos().y))

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
	elif !is_anim_playing("Guard"):
		Status.guarding = false

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

func is_anim_playing(action_name):
	var anim_name = Data.name + "_" + action_name + "_" + Status.direction
	var anim_node = Data.anims.get_node(anim_name)
	return anim_node.is_playing()
