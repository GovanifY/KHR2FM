extends CanvasLayer

# Ce script gère les fonctions globales du jeu les plus importantes, telles que
# le timer, la pause ou le fullscreen

# Signals
signal toggled_pause
signal pressed_pause

# Configuration file data
const PATH_CONFIG = "user://settings.cfg"
var config = ConfigFile.new()

# Global definitions
var global = {
	"Difficulty" : null,
	"Playtime" : {
		hrs  = 0,
		mins = 0,
	},
	"Map" : {
		player   = null,
		world    = null,
		location = null,
	},
	"Player" : null, # TODO: Player stats
}

######################
### Core functions ###
######################
func _enter_tree():
	# Loading config file
	var err = config.load(PATH_CONFIG)
	if err != OK: # Create a new one
		config.save(PATH_CONFIG)

func _exit_tree():
	# Saving config file
	config.save(PATH_CONFIG)

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

# Setter for global KHR2 variables
func _set(key, value):
	global[key] = value

# Getter for global KHR2 variables
func _get(key):
	return global[key]

func _notification(notif):
	if notif == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()

func _input(event):
	if event.is_pressed() && !event.is_echo():
		# Detect a quit ---> HIGH PRIORITY! Call the quit function right away
		if event.is_action("quit"):
			get_tree().quit()
		elif event.is_action("fullscreen"):
			fullscreen()
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
	var mins = get("Playtime").mins + 1
	if mins >= 60:
		get("Playtime").mins = 0
		get("Playtime").hrs += 1
	else:
		get("Playtime").mins = mins

###############
### Methods ###
###############
# Resets the global Playtime
func reset_playtime(mins=0, hrs=0):
	var playtime = get_node("Playtime")
	playtime.stop()
	get("Playtime").mins = min(max(0, int(mins)), 60)
	get("Playtime").hrs  = max(0, int(hrs))
	playtime.set_wait_time(60)
	playtime.start()

# Toggles/sets fullscreen
func fullscreen(value=!OS.is_window_fullscreen()):
	config.set_value("fullscreen", "enabled", value)
	OS.set_window_fullscreen(value)
	return value

# Returns the current pause scene's filename; null if non-existent
func get_pause():
	return get_node("Pause").get_filename() if has_node("Pause") else null

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
	if not has_node("Pause"):
		return # DO NOT PAUSE

	# Toggle pause and signal that it's been toggled
	get_tree().set_pause(value)
	emit_signal("toggled_pause")
