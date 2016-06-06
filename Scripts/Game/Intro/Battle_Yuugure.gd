extends Node2D
var state=0
#Yuugure:100HP!!
#Kiryoku vars
#0=gauche, 1=droite, 2=déjà effectué, aucun changement
var Kiryoku_direction=1
#Pour savoir si l'on est protégé des attaques
var guard=false

var keypressed=false
var keypressedguard=false
var left = false
var right = false
var confirm = false
var cancel = false

func _process(delta):
	if(state==0):
		get_node("Info_Popup").play("Info_Popup")
		state=1
	elif(state==1):
		if(!get_node("Info_Popup").is_playing()):
			get_node("/root/global").textscroll(get_node("Info_Label"), tr("INTRO_INFO_YUUGURE"), null, null)
			state=2
	elif(state==2 && !Globals.get("TextScrolling")):
		get_node("Info_Unpop").play("Info_Unpop")
		state=3
	elif(state==3):
		if(!get_node("Info_Unpop").is_playing()):
			state=4
			
	#Battle checks
	#Si kiryoku est immobile et selon sa direction on joue une anim'
	#A FAIRE POUR ANIM DE COMBAT: Ajouter offset a pos si offset n'est pas vide, clear offset si aucune anim' utilisant l'offset n'est joué
	#Pour l'attaque 3: Random de 0 a 2 pour Kir_5,6 ou 9(SE)
	#Attaque 3:quand offset=66 attaque 3=off
	if state==4:
		#Si on est en battle on prends les inputs!
		if Input.is_action_pressed("ui_left"):
			left = true
		else:
			left = false

		if Input.is_action_pressed("ui_right"):
			right = true
		else:
			right = false

		if Input.is_action_pressed("enter"):
			confirm = true
		else:
			confirm = false

		if Input.is_action_pressed("cancel"):
			cancel = true
		else:
			cancel = false
	
	#Si les deux directions sont appuyées en même temps on garde seulement celle active en premier
	if(right==true&&left==true):
		if(get_node("Kiryoku/Kiryoku_Walk_Right").is_playing()):
			left=false
		else:
			right=false
	#Si la mauvaise anim' est joué on swap
	if((left==true && get_node("Kiryoku/Kiryoku_Walk_Right").is_playing()) || (right==true && get_node("Kiryoku/Kiryoku_Walk_Left").is_playing())):
		if (left==true):
			_stop_player_anim()
			get_node("Kiryoku/Kiryoku_Walk_Left").play("Kiryoku_Walk_Left")
		else:
			_stop_player_anim()
			get_node("Kiryoku/Kiryoku_Walk_Right").play("Kiryoku_Walk_Right")
	#L'anim' a jouer lorsque l'on appuie sur droite
	if(right==true && !get_node("Kiryoku/Kiryoku_Walk_Right").is_playing() && is_processing()==true) :
		keypressed=true
		Kiryoku_direction=1
		_stop_player_anim()
		get_node("Kiryoku/Kiryoku_Walk_Right").play("Kiryoku_Walk_Right")
		get_node("Kiryoku/Kiryoku_Sprite").set_pos(Vector2(get_node("Kiryoku/Kiryoku_Sprite").get_pos().x + 5, get_node("Kiryoku/Kiryoku_Sprite").get_pos().y))
	elif(right==true && get_node("Kiryoku/Kiryoku_Walk_Right").is_playing() && is_processing()==true):
		#Dans ce cas la l'anim' a déjà été lancée donc on continue juste!
		keypressed=true
		get_node("Kiryoku/Kiryoku_Sprite").set_pos(Vector2(get_node("Kiryoku/Kiryoku_Sprite").get_pos().x + 5, get_node("Kiryoku/Kiryoku_Sprite").get_pos().y))
		
	#L'anim' a jouer lorsque l'on appuie sur gauche
	if(left==true && !get_node("Kiryoku/Kiryoku_Walk_Left").is_playing() && is_processing()==true):
		keypressed=true
		Kiryoku_direction=0
		_stop_player_anim()
		get_node("Kiryoku/Kiryoku_Walk_Left").play("Kiryoku_Walk_Left")
		get_node("Kiryoku/Kiryoku_Sprite").set_pos(Vector2(get_node("Kiryoku/Kiryoku_Sprite").get_pos().x - 5, get_node("Kiryoku/Kiryoku_Sprite").get_pos().y))
	elif(left==true && get_node("Kiryoku/Kiryoku_Walk_Left").is_playing() && is_processing()==true):
		#Dans ce cas la l'anim' a déjà été lancée donc on continue juste!
		keypressed=true
		get_node("Kiryoku/Kiryoku_Sprite").set_pos(Vector2(get_node("Kiryoku/Kiryoku_Sprite").get_pos().x - 5, get_node("Kiryoku/Kiryoku_Sprite").get_pos().y))
	
	#L'anim' de garde(X), tout est stoppé lorsqu'on la joue
	if(cancel==true && keypressedguard==false && is_processing()==true):
		guard=true
		keypressedguard=true
		keypressed=true
		_stop_player_anim()
		if(Kiryoku_direction==0):
			get_node("Kiryoku/Kiryoku_Guard_Left").play("Kiryoku_Guard_Left")
		elif(Kiryoku_direction==1):
			get_node("Kiryoku/Kiryoku_Guard_Right").play("Kiryoku_Guard_Right")
	
	if (!get_node("Kiryoku/Kiryoku_Guard_Left").is_playing()) && (!get_node("Kiryoku/Kiryoku_Guard_Right").is_playing()):
		guard=false
		
	#L'anim' de combat
	if(confirm==true && is_processing()==true):
		print("yay")
	#L'anim 'still'
	if (left==false && right==false && is_processing()==true):
		if(Kiryoku_direction==0):
			if (!get_node("Kiryoku/Kiryoku_Still_Left").is_playing()):
				_stop_player_anim()
				get_node("Kiryoku/Kiryoku_Still_Left").play("Kiryoku_Still_Left")
		elif(Kiryoku_direction==1):
			if (!get_node("Kiryoku/Kiryoku_Still_Right").is_playing()):
				_stop_player_anim()
				get_node("Kiryoku/Kiryoku_Still_Right").play("Kiryoku_Still_Right")
		
	if (get_node("Kiryoku/Kiryoku_Sprite").get_pos().x <= -222):
		get_node("Kiryoku/Kiryoku_Sprite").set_pos(Vector2(-222,get_node("Kiryoku/Kiryoku_Sprite").get_pos().y))
	if (get_node("Kiryoku/Kiryoku_Sprite").get_pos().x >= 620):
		get_node("Kiryoku/Kiryoku_Sprite").set_pos(Vector2(620,get_node("Kiryoku/Kiryoku_Sprite").get_pos().y))
		
	if keypressedguard==true && cancel==false:
		keypressedguard=false
	if(keypressed==true && (left==false && right==false && confirm==false && cancel==false)):
		keypressed=false
	
	

func _ready():
	# Initialization here
	set_process(true)
	pass

func _stop_player_anim():
	get_node("Kiryoku/Kiryoku_Still_Right").stop()
	get_node("Kiryoku/Kiryoku_Still_Left").stop()
	get_node("Kiryoku/Kiryoku_Walk_Right").stop()
	get_node("Kiryoku/Kiryoku_Walk_Left").stop()
	get_node("Kiryoku/Kiryoku_Guard_Right").stop()
	get_node("Kiryoku/Kiryoku_Guard_Left").stop()
	get_node("Kiryoku/Kiryoku_Attack1_Right").stop()
	get_node("Kiryoku/Kiryoku_Attack2_Right").stop()
	get_node("Kiryoku/Kiryoku_Attack3_Right").stop()
	get_node("Kiryoku/Kiryoku_Attack1_Left").stop()
	get_node("Kiryoku/Kiryoku_Attack3_Left").stop()
	get_node("Kiryoku/Kiryoku_Attack1_Left").stop()

func is_processing():
	if (!get_node("Kiryoku/Kiryoku_Guard_Left").is_playing() && !get_node("Kiryoku/Kiryoku_Guard_Right").is_playing()):
		return true
	else:
		return false
