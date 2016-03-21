extends Node

#Ce script gère les fonctions globales du jeu qui se font dans le background
#tel que le timer, la save ou le fullscreen.
#Le script est en autoload.


var keypressed=false
var keypressedtext=false
#Un accumultaeur pour le timer
var accum=0
var textenabled=false
var text=null
var TextNode=null
var currentlywritten=""
var FRAME_TEXT_WAIT=1
var actualTimeWait=1
var SE=null
var SENm=null

#Pour les fonctions debug, a ne pas mettre en retail!
var debug=true


func _ready():
	# Initialization here
	set_process(true)
	Globals.set("PlayTimeMinutes", 0)
	Globals.set("PlayTimeHours", 0)
	Globals.set("TimerActivated", false)
	Globals.set("TextScrolling",false)
	pass

func _process(delta):
	if(Globals.get("TimerActivated")==true):
		accum+=delta
		if(accum>60):
			accum=0
			Globals.set("PlayTimeMinutes", Globals.get("PlayTimeMinutes") + 1)
			#C'est du débug, ca sers pas a grand chose
			#print("Time:", Globals.get("PlayTimeHours") ,":", Globals.get("PlayTimeMinutes"))
			if(Globals.get("PlayTimeMinutes")==60):
				Globals.set("PlayTimeHours", Globals.get("PlayTimeHours") + 1)
				if Globals.get("PlayTimeHours",100):
					Globals.set("PlayTimeHours", 99)
	var fs_pressed = false
	if Input.is_action_pressed("fullscreen"):
		fs_pressed = true
	if(fs_pressed == true && keypressed == false):
		keypressed=true
		if(OS.is_video_mode_fullscreen()):
			OS.set_window_fullscreen(false)
		elif(!OS.is_video_mode_fullscreen()):
			OS.set_window_fullscreen(true)
			
	if debug==true:
		if Input.is_action_pressed("debug_a"):
			get_node("/root/SceneLoader").goto_scene("res://Scenes/Splash/Splash.scn", false)
		if Input.is_action_pressed("debug_b"):
			get_node("/root/SceneLoader").goto_scene("res://Scenes/Splash/EXP_Zero.scn", false)
		if Input.is_action_pressed("debug_c"):
			get_node("/root/SceneLoader").goto_scene("res://Scenes/MainLoader.scn", false)
		if Input.is_action_pressed("debug_d"):
			get_node("/root/SceneLoader").goto_scene("res://Scenes/Game/Intro/Intro.scn", false)
		if Input.is_action_pressed("debug_e"):
			get_node("/root/SceneLoader").goto_scene("res://Scenes/Game/Intro/Aqua.scn", false)
		if Input.is_action_pressed("debug_f"):
			get_node("/root/SceneLoader").goto_scene("res://Scenes/Game/Intro/Battle_Yuugure.scn", false)
		if Input.is_action_pressed("debug_h"):
			get_node("/root/SceneLoader").goto_scene("res://Scenes/Demo/End_Demo.scn")
	if(textenabled==true):
		updateText()
	
	

	if(keypressed==true && fs_pressed==true):
		keypressed=false

func save():
	var savedict = {
		PlayTimeMinutes=Globals.get("PlayTimeMinutes"),
		PlayTimeHours=Globals.get("PlayTimeHours"),
		FaceSave=Globals.get("FaceSave"),
		Critical=Globals.get("Critical"),
		EXP_Zero=Globals.get("EXP_Zero"),
		LV=Globals.get("LV")
		}
	return savedict

func textscroll(node, texttouse, SENode, NameSE):
	if texttouse.length()==0:
		return
	currentlywritten=currentlywritten+texttouse[0]
	currentlywritten=currentlywritten.replace("|","\n")
	node.set_bbcode(currentlywritten)
	textenabled=true
	TextNode=node
	text=texttouse
	SE= SENode
	SENm = NameSE
	Globals.set("TextScrolling",true)
	
func updateText():
	var confirm=false
	if Input.is_action_pressed("enter"):
		confirm = true
		
	if(actualTimeWait!=0):
		actualTimeWait=actualTimeWait-1
	elif(actualTimeWait==0):
		actualTimeWait=FRAME_TEXT_WAIT
		if(currentlywritten.length() < text.length()):
			currentlywritten=currentlywritten+text[currentlywritten.length()]
			currentlywritten=currentlywritten.replace("|","\n")
			TextNode.set_bbcode(currentlywritten)
			

				
	if(currentlywritten.length() < text.length()):
		if(confirm == true && keypressedtext == false):
			currentlywritten=text.replace("|","\n")
			TextNode.set_bbcode(currentlywritten)
			keypressedtext=true
	if(currentlywritten.length()==text.length()):
		if(confirm == true && keypressedtext == false):
			if(SE!=null):
				SE.play(SENm)
			currentlywritten=""
			Globals.set("TextScrolling",false)
			TextNode.set_bbcode(currentlywritten)
			textenabled=false
			keypressedtext=true
				
	if(keypressedtext==true && confirm==false):
		keypressedtext=false