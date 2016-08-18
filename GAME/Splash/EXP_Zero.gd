extends Node2D

#Pour vérifier si le splash initial est terminé
var hasbeenset = false
var SelectMode=0
var keypressed=false
var EndAnim=false

func _process(delta):
	if (hasbeenset == false || EndAnim ==true):
		if(hasbeenset==false):
			if(!get_node("Show_EXP_Zero").is_playing()):
				#Si le splash est terminé et que les anims ont pas encore été lancées ont les lance.
				get_node("Cursor").play("Cursor")
				hasbeenset=true
		elif(EndAnim==true):
			if(!get_node("End").is_playing()):
				SceneLoader.add_scene("Intro/Aqua.tscn")
				SceneLoader.load_new_scene()
	else:
		var right = false
		var left = false
		var confirm = false

		#Le menu est lancé, donc il vaudrait mieux gérer les inputs de l'user!
		#On s'occupe ici de savoir les touches pressées
		if Input.is_action_pressed("ui_left"):
			left = true

		if Input.is_action_pressed("ui_right"):
			right = true

		if Input.is_action_pressed("enter"):
			confirm = true

		if (left == true && keypressed == false):
			get_node("System").play("System_03")
			SelectMode=SelectMode-1
			if SelectMode < 0:
				SelectMode=1
			keypressed=true
			if SelectMode == 1:
				get_node("EXP_Zero_002").set_opacity(0)
				get_node("EXP_Zero_003").set_opacity(1)
				get_node("EXP_Zero_001").set_opacity(1)
				get_node("EXP_Zero_000").set_opacity(0)
				get_node("left_touch").set_scale(Vector2(450,480))
				get_node("right_touch").set_pos(Vector2(630,0))
				get_node("right_touch").set_scale(Vector2(248,480))
				get_node("enter_touch").set_pos(Vector2(455,257))
			elif SelectMode == 0:
				get_node("EXP_Zero_002").set_opacity(1)
				get_node("EXP_Zero_003").set_opacity(0)
				get_node("EXP_Zero_001").set_opacity(0)
				get_node("EXP_Zero_000").set_opacity(1)
				get_node("left_touch").set_scale(Vector2(242,480))
				get_node("right_touch").set_scale(Vector2(445,480))
				get_node("right_touch").set_pos(Vector2(432,0))
				get_node("enter_touch").set_pos(Vector2(253,257))
			keypressed=true

		if (right == true && keypressed == false):
			get_node("System").play("System_03")
			SelectMode=SelectMode+1
			if SelectMode > 1:
				SelectMode=0
			keypressed=true
			if SelectMode == 1:
				get_node("EXP_Zero_002").set_opacity(0)
				get_node("EXP_Zero_003").set_opacity(1)
				get_node("EXP_Zero_001").set_opacity(1)
				get_node("EXP_Zero_000").set_opacity(0)
				get_node("left_touch").set_scale(Vector2(450,480))
				get_node("right_touch").set_pos(Vector2(630,0))
				get_node("right_touch").set_scale(Vector2(248,480))
				get_node("enter_touch").set_pos(Vector2(455,257))
			elif SelectMode == 0:
				get_node("EXP_Zero_002").set_opacity(1)
				get_node("EXP_Zero_003").set_opacity(0)
				get_node("EXP_Zero_001").set_opacity(0)
				get_node("EXP_Zero_000").set_opacity(1)
				get_node("left_touch").set_scale(Vector2(242,480))
				get_node("right_touch").set_scale(Vector2(445,480))
				get_node("right_touch").set_pos(Vector2(432,0))
				get_node("enter_touch").set_pos(Vector2(253,257))
			keypressed=true
		if (confirm == true && keypressed == false):
			if SelectMode==1:
				Globals.set("EXP_Zero",false)
			elif SelectMode==0:
				Globals.set("EXP_Zero",true)
			get_node("System").play("System_04")
			get_node("End").play("End")
			EndAnim=true
			keypressed=true

		if(keypressed==true && (right==false && left==false && confirm==false)):
			keypressed=false

func _ready():
	set_process(true)
	pass
