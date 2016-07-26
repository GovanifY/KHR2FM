extends KinematicBody2D

# Constants
const Battle_Action = preload("res://GAME/SCRIPTS/Battle/Battle_Action.gd")

# Export values
export(int, 1, 20) var player_speed = 5

# Données importantes sur le player
var Data = {
	# Various properties
	"side"  : Vector2(1, 1),
	# Nodes
	"anims" : null,  # Node type "Node" qui ne contient QUE DES "AnimationPlayer"
	"timer" : null   # Node type "Timer" pour les combo
}

# Status des actions du Player
var Status = {
	"action" : null,   # L'animation executée (Still, Walk...)
	"lock"   : false,
	"motion" : 0       # Integer pour l'abscisse du mouvement
}

var AnimList = {}
var Actions = {}

######################
### Core functions ###
######################
func _ready():
	# Initialization du Player
	Data.anims = get_node("anims")
	Data.timer = get_node("ComboTimer")

	# Adding "Guard"
	Actions.guard = Battle_Action.new("Guard", "cancel")
	Actions.guard.set_event("pressed", true)
	Actions.guard.set_event("echo", false)

	# Adding "Attack"
	Actions.attack = Battle_Action.new("Attack", "enter", 3)
	Actions.attack.set_timer(Data.timer)
	Actions.attack.set_event("pressed", true)
	Actions.attack.set_event("echo", false)

	for act in Actions:
		# Connecting Actions' signals
		var action_name = act.capitalize()
		var action_anim = Data.anims.get_node(action_name)
		action_anim.connect("finished", Actions[act], "_end_action")
		Actions[act].connect("combo", self, "_play_action")
		Actions[act].connect("finished", self, "_play_still")

		# Grabbing Action's animation list
		AnimList[action_name] = action_anim.get_animation_list()

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
		var left  = Input.is_action_pressed("ui_left")
		var right = Input.is_action_pressed("ui_right")

		# déterminer la priorité de direction
		if left && right:
			left  = is_facing("left")
			right = !left

		# Indiquer la direction finale
		if left || right:
			if left:    face("left")
			elif right: face("right")
			set_scale(Data.side)
			Status.motion = player_speed
		else:
			Status.motion = 0
	else:
		Status.motion = 0

func _fixed_process(delta):
	# Si le player doit bouger
	if Status.motion != 0:
		play_anim("Walk")
		var motion = _move(Status.motion)

# Custom move() operation
func _move(x):
	if typeof(x) != TYPE_INT:
		return Vector2(0, 0)

	if is_facing("left"):
		x *= -1
	return move(Vector2(x, 0))

func _action_lock():
	Status.lock = true

func _action_unlock():
	Status.lock = false

func _random_voice(snd_arr):
	var rng = randi() % snd_arr.size()
	get_node("Voice").play(snd_arr[rng])

#######################
### Signal routines ###
#######################
func _play_still():
	_action_unlock()
	play_anim("Still")

func _play_action(name, idx):
	play_anim(name, AnimList[name][idx])

###############
### Methods ###
###############
# Points the body towards the new direction
func face(direction):
	if not (direction in ["left", "right"]):
		return

	if direction.matchn("left"):
		Data.side.x = -1
	elif direction.matchn("right"):
		Data.side.x = 1

# Checks which direction we're going towards
func is_facing(direction):
	if not (direction in ["left", "right"]):
		return false

	if direction.matchn("left"):
		return Data.side.x == -1
	elif direction.matchn("right"):
		return Data.side.x == 1

## Réglage des animations
func stop_all_anims():
	# Chercher tous les Nodes d'animation
	var all_anims = Data.anims.get_children()
	for anim in all_anims:
		anim.stop()

func play_anim(anim_name, idx = anim_name):
	var anim_node = Data.anims.get_node(anim_name)

	if !anim_node.is_playing():
		if Status.action != null:
			Status.action.stop()
		Status.action = anim_node
		Status.action.play(idx)
		return true

	return false
