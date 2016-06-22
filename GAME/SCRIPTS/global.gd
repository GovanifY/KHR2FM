extends Node

# Ce script gère les fonctions globales du jeu qui se font dans le background
# tel que le timer, la save ou le fullscreen.
# Le script est en autoload.


var keypressed=false
# Un accumulateur pour le timer
var accum = 0
var debug = false

onready var SceneLoader = get_node("/root/SceneLoader")

func _ready():
	# Initialization here
	Globals.set("PlayTimeMinutes", 0)
	Globals.set("PlayTimeHours", 0)
	Globals.set("TimerActivated", false)

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
			SceneLoader.goto_scene("res://GAME/SCENES/Splash/Splash.tscn")
		elif InputMap.event_is_action(event, "debug_b"):
			SceneLoader.goto_scene("res://GAME/SCENES/Splash/EXP_Zero.tscn")
		elif InputMap.event_is_action(event, "debug_c"):
			SceneLoader.goto_scene("res://GAME/SCENES/MainLoader.tscn")
		elif InputMap.event_is_action(event, "debug_d"):
			SceneLoader.goto_scene("res://GAME/SCENES/Game/Intro/Intro.tscn")
		elif InputMap.event_is_action(event, "debug_e"):
			SceneLoader.goto_scene("res://GAME/SCENES/Game/Intro/Aqua.tscn")
		elif InputMap.event_is_action(event, "debug_f"):
			SceneLoader.goto_scene("res://GAME/SCENES/Game/Intro/Battle_Yuugure.tscn")
		elif InputMap.event_is_action(event, "debug_h"):
			SceneLoader.goto_scene("res://GAME/SCENES/Demo/End_Demo.tscn")

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
