extends Node

# Ce script gère les fonctions globales du jeu qui se font dans le background
# tel que le timer, la save ou le fullscreen.
# Le script est en autoload.


var keypressed=false
# Un accumulateur pour le timer
var accum = 0
var debug = false

func _ready():
	Globals.set("PlayTimeMinutes", 0)
	Globals.set("PlayTimeHours", 0)
	Globals.set("TimerActivated", false)

	# For extended debugging purposes
	debug = OS.is_debug_build()

	set_process_input(true)
	set_process(true)

func _notification(notif):
	if notif == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		quit_game()

func _input(event):
	# Detect a quit ---> HIGH PRIORITY! Call the quit function right away
	if InputMap.event_is_action(event, "quit"):
		quit_game()

	# FullScreen-related actions
	var fs_pressed = InputMap.event_is_action(event, "fullscreen")
	if fs_pressed && !keypressed:
		keypressed = true
		OS.set_window_fullscreen(!OS.is_video_mode_fullscreen())
	if !fs_pressed && keypressed:
		keypressed = false

	# Debugging stuff, ignore this
	if debug:
		if InputMap.event_is_action(event, "debug_a"):
			SceneLoader.add_scene("Splash/Splash.tscn")
		elif InputMap.event_is_action(event, "debug_b"):
			SceneLoader.add_scene("Splash/EXP_Zero.tscn")
		elif InputMap.event_is_action(event, "debug_d"):
			SceneLoader.add_scene("Game/Intro/Intro.tscn")
		elif InputMap.event_is_action(event, "debug_e"):
			SceneLoader.add_scene("Game/Intro/Aqua.tscn")
		elif InputMap.event_is_action(event, "debug_f"):
			SceneLoader.add_scene("Game/Intro/Battle_Yuugure.tscn")
		elif InputMap.event_is_action(event, "debug_h"):
			SceneLoader.add_scene("Demo/End_Demo.tscn")

		if SceneLoader.is_there_a_scene():
			SceneLoader.load_new_scene()

func _process(delta):
	# Global Timer
	if Globals.get("TimerActivated"):
		accum += delta
		if accum >= 60:
			accum = 0
			Globals.set("PlayTimeMinutes", Globals.get("PlayTimeMinutes") + 1)
			#C'est du débug, ca sers pas a grand chose
			#print("Time:", Globals.get("PlayTimeHours") ,":", Globals.get("PlayTimeMinutes"))
			if Globals.get("PlayTimeMinutes") >= 60:
				Globals.set("PlayTimeHours", Globals.get("PlayTimeHours") + 1)


func quit_game():
	SceneLoader.kill_thread()
	get_tree().quit()
