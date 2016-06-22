extends Node

# Ce script gère les fonctions globales du jeu qui se font dans le background
# tel que le timer, la save ou le fullscreen.
# Le script est en autoload.


var keypressed=false
var keypressedtext=false
# Un accumulateur pour le timer
var accum = 0
const FRAME_TEXT_WAIT = 1
var Text = {
	"node" : null,
	"enabled" : false,
	"timer" : 1,
	"length" : 0
}
var SE = {
	"node" : null,
	"name" : null
}
var debug = false


func _ready():
	# Initialization here
	Globals.set("PlayTimeMinutes", 0)
	Globals.set("PlayTimeHours", 0)
	Globals.set("TimerActivated", false)
	Globals.set("TextScrolling",false)

	# For extended debugging purposes
	debug = OS.is_debug_build()

	set_process_input(true)
	set_process(true)

func _input(event):
	# Detect a quit ---> HIGH PRIORITY! Call the quit function right away
	if InputMap.event_is_action(event, "quit"):
		get_tree().quit()

	# FullScreen-related actions
	var fs_pressed = false
	if InputMap.event_is_action(event, "fullscreen"):
		fs_pressed = true
	if fs_pressed && !keypressed:
		keypressed = true
		OS.set_window_fullscreen(!OS.is_video_mode_fullscreen())
	if !fs_pressed && keypressed:
		keypressed = false

	# Debugging stuff, ignore this
	if debug:
		if InputMap.event_is_action(event, "debug_a"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Splash/Splash.tscn")
		elif InputMap.event_is_action(event, "debug_b"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Splash/EXP_Zero.tscn")
		elif InputMap.event_is_action(event, "debug_c"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/MainLoader.tscn")
		elif InputMap.event_is_action(event, "debug_d"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Game/Intro/Intro.tscn")
		elif InputMap.event_is_action(event, "debug_e"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Game/Intro/Aqua.tscn")
		elif InputMap.event_is_action(event, "debug_f"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Game/Intro/Battle_Yuugure.tscn")
		elif InputMap.event_is_action(event, "debug_h"):
			get_node("/root/SceneLoader").goto_scene("res://GAME/SCENES/Demo/End_Demo.tscn")

func _process(delta):
	if Globals.get("TimerActivated"):
		accum += delta
		if accum > 60:
			accum = 0
			Globals.set("PlayTimeMinutes", Globals.get("PlayTimeMinutes") + 1)
			#C'est du débug, ca sers pas a grand chose
			#print("Time:", Globals.get("PlayTimeHours") ,":", Globals.get("PlayTimeMinutes"))
			if Globals.get("PlayTimeMinutes") == 60:
				Globals.set("PlayTimeHours", Globals.get("PlayTimeHours") + 1)
				if Globals.get("PlayTimeHours",100):
					Globals.set("PlayTimeHours", 99)

	# The infamous text scroll
	if Text.enabled:
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
	Text.length = Text.node.get_bbcode().length()

func update_text():
	var confirm = false
	var chars_written = Text.node.get_visible_characters()

	# Are we in a hurry?
	if Input.is_action_pressed("enter"):
		confirm = true

	# Check for timer: write a character if it's gone to 0, wait otherwise
	if Text.timer != 0:
		Text.timer-=1
	elif Text.timer == 0:
		Text.timer = FRAME_TEXT_WAIT
		if chars_written < Text.length:
			chars_written+=1
			Text.node.set_visible_characters(chars_written)

	# If "enter" action was pressed:
	if confirm == true && keypressedtext == false:
		# if we're still writing, write everything
		if chars_written < Text.length:
			chars_written = Text.length
			Text.node.set_visible_characters(chars_written)
			keypressedtext=true

		# if we're done writing, clear everything
		elif chars_written == Text.length:
			if SE.node != null:
				SE.node.play(SE.name)
			Globals.set("TextScrolling",false)
			Text.node.clear()
			Text.enabled=false
			keypressedtext=true

	if confirm == false && keypressedtext == true:
		keypressedtext = false
