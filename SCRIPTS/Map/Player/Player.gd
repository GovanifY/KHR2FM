extends KinematicBody2D

const MOTION_SPEED = 160 # Pixels/seconds
func _ready():
	set_process_input(true)
	set_fixed_process(true)

func _fixed_process(delta):
	var motion = Vector2()
	
	if (Input.is_action_pressed("ui_up")):
		motion += Vector2(0, -1)
	if (Input.is_action_pressed("ui_down")):
		motion += Vector2(0, 1)
	if (Input.is_action_pressed("ui_left")):
		motion += Vector2(-1, 0)
	if (Input.is_action_pressed("ui_right")):
		motion += Vector2(1, 0)
	
	motion = motion.normalized()*MOTION_SPEED*delta
	motion = move(motion)
func _input(event):
	var left  = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var up  = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")

	if up and right == false and left== false:
		get_node("anims").play("up")
	elif down and right == false and left == false:
		get_node("anims").play("down")
	elif up and right and left == false:
		get_node("anims").play("up_right")
	elif up and left and right == false:
		get_node("anims").play("up_left")
	elif down and right and left == false:
		get_node("anims").play("down_right")
	elif down and left and right == false:
		get_node("anims").play("down_left")
	elif left and down == false and up == false:
		get_node("anims").play("left")
	elif right and down == false and up == false:
		get_node("anims").play("right")
	else:
		var last_anim = get_node("anims").get_current_animation()
		get_node("anims").stop()
		if last_anim == "up":
			get_node("Sprite").set_frame(27)
		elif last_anim == "down":
			get_node("Sprite").set_frame(0)
		elif last_anim == "left":
			get_node("Sprite").set_frame(9)
		elif last_anim == "right":
			get_node("Sprite").set_frame(18)
		elif last_anim == "up_right":
			get_node("Sprite").set_frame(63)
		elif last_anim == "up_left":
			get_node("Sprite").set_frame(54)
		elif last_anim == "down_right":
			get_node("Sprite").set_frame(45)
		elif last_anim == "down_left":
			get_node("Sprite").set_frame(54)




