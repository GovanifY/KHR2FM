extends KinematicBody2D

# Constants
const Battle_Action = preload("res://GAME/SCRIPTS/Battle/Battle_Action.gd")

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
	"sprite" : null,     # Node type "Sprite" ou "AnimatedSprite"
	"timer"  : null
}

# Status des actions du Player
var Status = {
	"action" : null,   # L'animation executée (Still, Walk...)
	"lock"   : false,
	"motion" : 0       # Integer pour l'abscisse du mouvement
}

var Actions = {}

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
	Data.timer = get_node("Actions/ComboTimer")

	# Adding "Guard"
	Actions.guard = Battle_Action.new(Data.anims, "Guard", "cancel")
	Actions.guard.set_event("pressed", true)
	Actions.guard.set_event("echo", false)

	# Adding "Attack"
	Actions.attack = Battle_Action.new(Data.anims, "Attack", "enter", 3)
	Actions.attack.set_timer(Data.timer)
	Actions.attack.set_event("pressed", true)
	Actions.attack.set_event("echo", false)

	# Connecting Actions' signals
	for act in Actions:
		Actions[act].connect("finished", self, "_play_still")

	# Player gains control
	_play_still()
	set_process_input(true)
	set_fixed_process(true)

func _input(event):
	# Handling Actions
	if !Status.lock:
		for act in Actions:
			if Actions[act].check_event(event):
				_action_lock()
				Status.action.stop()
				Actions[act].take_event(event)

	# Simple Input check
	var left    = Input.is_action_pressed("ui_left")
	var right   = Input.is_action_pressed("ui_right")

	# déterminer la priorité de direction
	if left && right:
		left  = Data.sprite.is_flipped_h()
		right = !left

	# Indiquer la direction finale
	if left || right:
		Data.sprite.set_flip_h(left)
		Status.motion = Data.speed
	else:
		Status.motion = 0

func _fixed_process(delta):
	# FIXME: Swap this crap with physics-based walls
	do_limit_pos()

	# Si le player doit bouger
	if Status.motion != 0:
		play_anim("Walk")
		var motion = _move(Status.motion)

	if Data.timer.get_time_left() > 0:
		print(Data.timer.get_time_left())

# Custom move() operation
func _move(x):
	if Data.sprite.is_flipped_h():
		x *= -1
	return move(Vector2(x, Data.height))

func _action_lock():
	Status.lock = true

func _action_unlock():
	Status.lock = false

#######################
### Signal routines ###
#######################
func _play_still():
	_action_unlock()
	play_anim("Still")

###############
### Methods ###
###############
## Actions
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
	var anim_node = Data.anims.get_node(action_name)

	if !anim_node.is_playing():
		if Status.action != null:
			Status.action.stop()
		Status.action = anim_node
		Status.action.play(action_name)
		return true

	return false
