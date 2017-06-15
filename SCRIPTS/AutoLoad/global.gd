extends Node

# Ce script gère les fonctions globales du jeu les plus importantes, telles que
# le timer, la pause ou le fullscreen

# Signals
signal toggle_pause

var Playtime = Timer.new()

######################
### Core functions ###
######################
func _enter_tree():
	Globals.set("Pause", null)

func _ready():
	# Timer-related
	Playtime.connect("timeout", self, "_playtime")
	add_child(Playtime)

	# Final settings
	set_pause_mode(PAUSE_MODE_PROCESS)
	set_process_input(true)

func _notification(notif):
	if notif == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()

func _input(event):
	if event.is_pressed() && !event.is_echo():
		# Detect a quit ---> HIGH PRIORITY! Call the quit function right away
		if event.is_action("quit"):
			get_tree().quit()
		elif event.is_action("fullscreen"):
			OS.set_window_fullscreen(!OS.is_window_fullscreen())
		elif event.is_action("pause"):
			pause_game()

		# Debugging stuff, ignore this
		if OS.is_debug_build():
			if event.is_action("reload_scene"):
				# Unpause the game if it's paused
				if get_tree().is_paused():
					pause_game()
				get_tree().reload_current_scene()
			elif event.is_action("debug"):
				var debug_name = "DebugCMD"
				var debug_path = "res://SCENES/Debug/" + debug_name + ".tscn"

				if !Globals.get(debug_name):
					SceneLoader.load_scene(debug_path, SceneLoader.BACKGROUND | SceneLoader.HIGH_PRIORITY)
					SceneLoader.show_scene(debug_path)
					Globals.set(debug_name, true)
				else:
					SceneLoader.erase_scene(debug_path)
					Globals.set(debug_name, false)
			elif event.is_action("quick_save"):
				SaveManager.save_game(0)
			elif event.is_action("quick_load"):
				SaveManager.load_game(0)
				SceneLoader.load_scene(SaveManager.get_scene())
		return


#######################
### Signal routines ###
#######################
func _playtime():
	var mins = Globals.get("PlaytimeMinutes") + 1
	var hrs  = Globals.get("PlaytimeHours")
	Globals.set("PlaytimeMinutes", mins)
	if mins >= 60:
		Globals.set("PlaytimeMinutes", 0)
		Globals.set("PlaytimeHours", hrs + 1)

###############
### Methods ###
###############
# Resets the global Playtime
func reset_playtime(mins=0, hrs=0):
	Playtime.stop()
	Globals.set("PlaytimeMinutes", mins)
	Globals.set("PlaytimeHours", hrs)
	Playtime.set_wait_time(60)
	Playtime.start()

# Properly pauses/unpauses the game
func pause_game():
	if Globals.get("Pause") == null:
		return # DO NOT PAUSE

	# Toggle pause and signal that it's been toggled
	get_tree().set_pause(!get_tree().is_paused())
	emit_signal("toggle_pause")
