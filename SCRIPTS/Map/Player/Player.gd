extends KinematicBody2D

func _ready():
	set_process_input(true)
	
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
		get_node("anims").stop()

	


