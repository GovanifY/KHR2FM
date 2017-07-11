extends CanvasLayer

# Ce script gère les fonctions globales du jeu les plus importantes, telles que
# le timer, la pause ou le fullscreen

# Signals
signal toggled_pause
signal pressed_pause

######################
### Core functions ###
######################
func _enter_tree():
	# Setting Map Dictionary
	if Globals.get("Map") == null:
		Globals.set("Map", {
			player   = null,
			world    = null,
			location = null,
		})

func _ready():
	# Setting timer for Playtime
	var playtime = Timer.new()
	playtime.set_name("Playtime")
	playtime.connect("timeout", self, "_playtime")
	add_child(playtime)

	# Final settings
	set_layer(100)
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
			emit_signal("pressed_pause")

		# Debugging stuff, ignore this
		if OS.is_debug_build():
			if event.is_action("reload_scene"):
				# Unpause the game if it's paused
				pause_game(false)
				get_tree().reload_current_scene()

			elif event.is_action("debug"):
				var debug_name = "DebugCMD"
				var debug_path = "res://SCENES/Debug/" + debug_name + ".tscn"

				if !has_node(debug_name):
					SceneLoader.load_scene(debug_path, SceneLoader.BACKGROUND | SceneLoader.HIGH_PRIORITY)
					SceneLoader.show_scene(debug_path)
				else:
					SceneLoader.erase_scene(get_node(debug_name))

			elif event.is_action("quick_save"):
				SaveManager.quick_save()
			elif event.is_action("quick_load"):
				SaveManager.quick_load()
				SceneLoader.load_scene(SaveManager.current_slot.get_scene())
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
	var playtime = get_node("Playtime")
	playtime.stop()
	Globals.set("PlaytimeMinutes", mins if mins != null else 0)
	Globals.set("PlaytimeHours", hrs if hrs != null else 0)
	playtime.set_wait_time(60)
	playtime.start()

# Returns the current pause scene's filename; null if non-existent
func get_pause():
	if KHR2.has_node("Pause"):
		return KHR2.get_node("Pause").get_filename()
	return null

# Sets the next general Pause scene with given PackedScene
func set_pause(packed_scene):
	var pause
	if has_node("Pause"):
		pause = get_node("Pause")
		pause.set_name("freeing")
		pause.queue_free()

	if packed_scene == null:
		return

	pause = packed_scene.instance()
	pause.set_name("Pause")
	pause.hide()
	add_child(pause)

func pause_game(value=!get_tree().is_paused()):
	if !has_node("Pause"):
		return # DO NOT PAUSE

	# Toggle pause and signal that it's been toggled
	get_tree().set_pause(value)
	emit_signal("toggled_pause")
