extends Node

# Ce script gère les fonctions globales du jeu qui se font dans le background
# tel que le timer, la save ou le fullscreen.
# Le script est en autoload.


# Un accumulateur pour le timer
var accum = 0
var debug = false

######################
### Core functions ###
######################
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
	if event.is_pressed() && !event.is_echo():
		# Detect a quit ---> HIGH PRIORITY! Call the quit function right away
		if InputMap.event_is_action(event, "quit"):
			quit_game()

		if InputMap.event_is_action(event, "fullscreen"):
			OS.set_window_fullscreen(!OS.is_video_mode_fullscreen())
			return

		# Debugging stuff, ignore this
		if debug:
			if InputMap.event_is_action(event, "debug_a"):
				SceneLoader.add_scene("Splash/Splash.tscn")
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

# Determines if the given string is valid
func _is_valid_string(string):
	return typeof(string) != TYPE_STRING && !string.empty()

###############
### Methods ###
###############
# Properly quits the game. If quitting needs to be more complex, this is the place to go
func quit_game():
	SceneLoader.kill_all_threads()
	get_tree().quit()

# Loads a node via a path and puts it in /root above the current scene.
func load_node(path, name):
	var exts = ["gd"]
	if !_is_valid_string(path) || !_is_valid_string(name):
		printerr("Given arguments aren't valid Strings")
		return false
	elif not (path.extension() in exts):
		printerr("File must contain one of these extensions:")
		printerr(exts)
		return false

	var root = get_node("/root")
	var node = load(path)

	if node == null:
		printerr("Couldn't load file")
		return false

	root.add_child(node)
	node.set_name(name)
	node.raise()

	Globals.set(name, true)
	return true

# Unloads a node from /root. BE VERY CAREFUL WITH THIS!!!
func unload_node(path):
	var exceptions = ["KHR2", "AudioRoom", "SceneLoader"]
	if !_is_valid_string(path):
		return false
	for global in exceptions:
		if path.findn(global):
			printerr("As a safety measure, I cannot unload \"%s\"" % global)
			return false

	var root = get_node("/root")
	var node = root.get_node(NodePath(path))
	var name = node.get_name()

	if node == null:
		printerr("Couldn't load node from root")
		return false

	root.remove_child(node)
	node.queue_free()

	Globals.set(name, false)
	return true
