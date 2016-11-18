extends KinematicBody2D

# Instance members
onready var Anims     = get_node("anims")
onready var Character = get_node("Character")

const MOTION_SPEED = 300 # Pixels/second

######################
### Core functions ###
######################
func _ready():
	set_process_input(true)
	set_fixed_process(true)

# Totally stolen from isometric example but eh
func _fixed_process(delta):
	var motion = Vector2()

	if Input.is_action_pressed("ui_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		motion += Vector2(1, 0)

	motion = motion.normalized() * MOTION_SPEED * delta
	motion = move(motion)

	# Make character slide nicely through the world
	# tl;dr slides when collisions detected
	var slide_attempts = 4
	while is_colliding() and slide_attempts > 0:
		motion = get_collision_normal().slide(motion)
		motion = move(motion)
		slide_attempts -= 1

func _input(event):
	var left  = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var up    = Input.is_action_pressed("ui_up")
	var down  = Input.is_action_pressed("ui_down")

	if up && not right && not left:
		Anims.play("up")
	elif down && not right && not left:
		Anims.play("down")
	elif up && right && not left:
		Anims.play("up_right")
	elif up && left && not right:
		Anims.play("up_left")
	elif down && right && not left:
		Anims.play("down_right")
	elif down && left && not right:
		Anims.play("down_left")
	elif left && not down && not up:
		Anims.play("left")
	elif right && not down && not up:
		Anims.play("right")
	else:
		var last_anim = Anims.get_current_animation()
		Anims.stop()
		if last_anim == "up":
			Character.set_frame(27)
		elif last_anim == "down":
			Character.set_frame(0)
		elif last_anim == "left":
			Character.set_frame(9)
		elif last_anim == "right":
			Character.set_frame(18)
		elif last_anim == "up_right":
			Character.set_frame(63)
		elif last_anim == "up_left":
			Character.set_frame(54)
		elif last_anim == "down_right":
			Character.set_frame(45)
		elif last_anim == "down_left":
			Character.set_frame(54)
