extends Node

#Ce script gère les fonctions globales du jeu qui se font dans le background
#tel que le timer, la save ou le fullscreen.
#Le script est en autoload.


var keypressed=false
var keypressedtext=false
#Un accumultaeur pour le timer
var accum=0
const FRAME_TEXT_WAIT=1
var Text = {
	"node" : null,
	"enabled" : false,
	"timer" : 1
}
var SE = {
	"node" : null,
	"name" : null
}
var debug = false


func _ready():
	# Initialization here
	set_process(true)
	Globals.set("PlayTimeMinutes", 0)
	Globals.set("PlayTimeHours", 0)
	Globals.set("TimerActivated", false)
	Globals.set("TextScrolling",false)
	#if OS.is_debug_build():
	#	debug=true
	#else:
	#	debug=false

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

	# Detect a quit ---> HIHG PRIORITY! Call the quit function right away
	if Input.is_action_pressed("quit"):
		get_tree().quit()

	# FullScreen-related actions
	var fs_pressed = false
	if Input.is_action_pressed("fullscreen"):
		fs_pressed = true
	if(fs_pressed == true && keypressed == false):
		keypressed=true
		if(OS.is_video_mode_fullscreen()):
			OS.set_window_fullscreen(false)
		elif(!OS.is_video_mode_fullscreen()):
			OS.set_window_fullscreen(true)
	if(keypressed==true && fs_pressed==false):
		keypressed=false

	# Debugging stuff, ignore this
	if debug==true:
		if Input.is_action_pressed("debug_a"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Splash/Splash.tscn", false)
		if Input.is_action_pressed("debug_b"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Splash/EXP_Zero.tscn", false)
		if Input.is_action_pressed("debug_c"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/MainLoader.tscn", false)
		if Input.is_action_pressed("debug_d"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Game/Intro/Intro.tscn", false)
		if Input.is_action_pressed("debug_e"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Game/Intro/Aqua.tscn", false)
		if Input.is_action_pressed("debug_f"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Game/Intro/Battle_Yuugure.tscn", false)
		if Input.is_action_pressed("debug_h"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Demo/End_Demo.tscn")

	# The infamous text scroll
	if(Text.enabled==true):
		update_text()



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

func textscroll(node, texttouse, SENode, SEName):
	# Si le texte est en blanc, ignorer
	if texttouse.length() == 0:
		return
	# Important assertions
	assert(node != null)

	Text.enabled = true
	Text.node = node
	SE.node = SENode
	SE.name = SEName
	Globals.set("TextScrolling",true)

	texttouse = texttouse.replace("\\n", "\n")
	Text.node.set_bbcode(texttouse)
	Text.node.set_visible_characters(1)

func update_text():
	var confirm = false
	var chars_written = Text.node.get_visible_characters()
	var text_length = Text.node.get_bbcode().length()

	# Are we in a hurry?
	if Input.is_action_pressed("enter"):
		confirm = true

	# Check for timer: write a character if it's gone to 0, wait otherwise
	if Text.timer != 0:
		Text.timer-=1
	elif Text.timer == 0:
		Text.timer = FRAME_TEXT_WAIT
		if chars_written < text_length:
			chars_written+=1
			Text.node.set_visible_characters(chars_written)

	# If "enter" action was pressed:
	if confirm == true && keypressedtext == false:
		# if we're still writing, write everything
		if chars_written < text_length:
			chars_written = text_length
			Text.node.set_visible_characters(chars_written)
			keypressedtext=true

		# if we're done writing, clear everything
		elif chars_written == text_length:
			if SE.node != null:
				SE.node.play(SE.name)
			Globals.set("TextScrolling",false)
			Text.node.clear()
			Text.enabled=false
			keypressedtext=true

	if confirm == false && keypressedtext == true:
		keypressedtext = false
