extends Node

# Ce script gère les fonctions globales du jeu qui se font dans le background
# tel que le timer, la save ou le fullscreen.

# Signals
signal toggle_pause

# Un accumulateur pour le timer
var accum = 0

######################
### Core functions ###
######################
func _ready():
	Globals.set("PlayTimeMinutes", 0)
	Globals.set("PlayTimeHours", 0)
	Globals.set("TimerActivated", false)

	# Protecting against pause
	set_pause_mode(PAUSE_MODE_PROCESS)

	set_process_input(true)
	set_process(true)

func _notification(notif):
	if notif == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		quit_game()

func _input(event):
	if event.is_pressed() && !event.is_echo():
		# Detect a quit ---> HIGH PRIORITY! Call the quit function right away
		if event.is_action("quit"):
			quit_game()
		elif event.is_action("fullscreen"):
			OS.set_window_fullscreen(!OS.is_video_mode_fullscreen())
		elif event.is_action("pause"):
			pause_game()

		# Debugging stuff, ignore this
		if OS.is_debug_build():
			if event.is_action("reload_scene"):
				get_tree().reload_current_scene()
			elif event.is_action("debug"):
				var debug_path = "res://SCENES/Debug/DebugCMD.tscn"
				var debug_name = "DebugCMD"

				if !Globals.get(debug_name):
					SceneLoader.load_scene(debug_path, true)
					SceneLoader.show_scene(debug_path)
					Globals.set(debug_name, true)
				else:
					get_node("/root/" + debug_name).free()
					SceneLoader.erase_scene(debug_path)
					Globals.set(debug_name, false)
		return

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

###############
### Methods ###
###############
# Properly quits the game. If quitting needs to be more complex, this is the place to go
func quit_game():
	SceneLoader.kill_all_threads()
	get_tree().quit()

func pause_game():
	get_tree().set_pause(!get_tree().is_paused())
	emit_signal("toggle_pause")
