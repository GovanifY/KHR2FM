extends KinematicBody2D

# Constants
const MOTION_SPEED = 300 # Pixels/second
const PATH_HUD = "res://SCENES/Map/HUD.tscn"

enum {
	SPR_UP = 1, SPR_DOWN = 2, SPR_LEFT = 4, SPR_RIGHT = 8,
}

# Instance members
onready var HUD  = KHR2.get_node("HUD")
onready var Anims     = get_node("anims")
onready var Character = get_node("Character")
var interacting = []

# "Private" members
onready var sprite_direction = { # All 8 directions from this project's spriteset layout
	SPR_UP               : "up"        ,
	SPR_DOWN             : "down"      ,
	SPR_LEFT             : "left"      ,
	SPR_RIGHT            : "right"     ,
	SPR_UP   | SPR_LEFT  : "up_left"   ,
	SPR_UP   | SPR_RIGHT : "up_right"  ,
	SPR_DOWN | SPR_LEFT  : "down_left" ,
	SPR_DOWN | SPR_RIGHT : "down_right",
}
onready var sprite_motion = {
	SPR_UP               : Vector2( 0, -1),
	SPR_DOWN             : Vector2( 0,  1),
	SPR_LEFT             : Vector2(-1,  0),
	SPR_RIGHT            : Vector2( 1,  0),
	SPR_UP   | SPR_LEFT  : Vector2(-1, -1),
	SPR_UP   | SPR_RIGHT : Vector2( 1, -1),
	SPR_DOWN | SPR_LEFT  : Vector2(-1,  1),
	SPR_DOWN | SPR_RIGHT : Vector2( 1,  1),
}

######################
### Core functions ###
######################
func _enter_tree():
	Globals.get("Map").player = self
	SceneLoader.load_scene(PATH_HUD, SceneLoader.BACKGROUND)
	SceneLoader.show_scene(PATH_HUD)

func _exit_tree():
	Globals.get("Map").player = null
	SceneLoader.erase_scene(HUD)

func _ready():
	start()

func _fixed_process(delta):
	# Grabbing directions from Input and transforming them into flags
	var directions = int(Input.is_action_pressed(sprite_direction[SPR_UP]))    << 0
	directions    |= int(Input.is_action_pressed(sprite_direction[SPR_DOWN]))  << 1
	directions    |= int(Input.is_action_pressed(sprite_direction[SPR_LEFT]))  << 2
	directions    |= int(Input.is_action_pressed(sprite_direction[SPR_RIGHT])) << 3

	# If it can animate the character, then it can move
	if _animate_character(directions):
		_move_character(directions, delta)

func _input(event):
	interact(event)

# Character animation cycle
func _start_animation(new_anim):
	if new_anim != Anims.get_current_animation() || !Anims.is_playing():
		Anims.play(new_anim)

func _stop_animation():
	Anims.stop()
	var idle_frame = Character.get_frame() - (Character.get_frame() % Character.hframes)
	Character.set_frame(idle_frame)

# Movement
func _animate_character(directions):
	# If it can move to this direction
	if sprite_direction.has(directions):
		_start_animation(sprite_direction[directions])
	else:
		_stop_animation()
	return Anims.is_playing()

func _move_character(directions, delta=0):
	var motion = sprite_motion[directions]
	motion = motion.normalized() * MOTION_SPEED * delta
	motion = move(motion)

	# Make character slide when collisions are detected
	var slide_attempts = 4
	while is_colliding() and slide_attempts > 0:
		motion = get_collision_normal().slide(motion)
		motion = move(motion)
		slide_attempts -= 1

###############
### Methods ###
###############
func get_type():
	return "MapPlayer"

func is_type(type):
	return type == get_type()

func start():
	set_fixed_process(true)
	set_process_input(true)

func stop():
	_stop_animation()
	set_fixed_process(false)
	set_process_input(false)


# Object interaction-related
func interact(event):
	if !can_interact():
		return

	if event.is_pressed() && !event.is_echo():
		if event.is_action("ui_accept"):
			# FIXME: Currently, using the last node touched
			interacting.front().emit_signal("interacted")

func can_interact():
	return not interacting.empty()

func add_interacting(body):
	interacting.push_front(body)
	HUD.set_command(HUD.interact, body.get_type())
	HUD.interact.show()

func has_interacting(body):
	return (body in interacting)

func erase_interacting(body):
	interacting.erase(body)
	if !can_interact():
		HUD.interact.hide()
