extends Control

# Signals
signal has_queued
signal has_loaded

# Flags
enum { BACKGROUND = 0x1, HIGH_PRIORITY = 0x2 }

# Instance members
var ThreadLoader = preload("res://SCRIPTS/AutoLoad/Loading/ThreadLoader.gd").new()
var next_scenes = []
var loaded_scenes = []

# "Private" members
onready var root = get_tree().get_root()

######################
### Core functions ###
######################
func _exit_tree():
	ThreadLoader.clear()

func _ready():
	ThreadLoader.set_progress_node(get_node("Progress"))
	ThreadLoader.connect("finished", self, "_scene_was_loaded")
	connect("visibility_changed", self, "_on_visibility_changed")

func _process(delta):
	var scene = next_scenes.front()
	if ThreadLoader.is_ready(scene):
		show_scene(scene, true)
		hide()

	# If we're done here, stop processing
	if get_tree().get_current_scene() != null:
		hide()

func _scene_was_loaded(path):
	loaded_scenes.push_back(path)
	emit_signal("has_loaded")

func _on_visibility_changed():
	KHR2.set_process_input(is_hidden())
	set_process(!is_hidden())

########################
### Helper functions ###
########################
static func get_filename_from(path):
	return path.get_file().replace(".tscn", "")

###############
### Methods ###
###############
func has_queued():
	return next_scenes.size() > 0

func has_loaded():
	return loaded_scenes.size() > 0

func queue_scene(path):
	if typeof(path) != TYPE_STRING:
		print("SceneLoader: Path must be a string.")
		return false

	var f = File.new()
	if !f.file_exists(path):
		print("SceneLoader: File not found:\t'", path, "'")
		return false

	if ThreadLoader.has(path):
		print("SceneLoader: '", path, "' was already queued.")
		return false

	# Pushing given scene as reference
	next_scenes.push_back(path)
	emit_signal("has_queued")
	return true

# Adds the given resources to queue to load them with given flags
func load_scene(path, flags=0):
	if queue_scene(path):
		return load_next_scene(flags)

# Begins loading the first scene in the queue
func load_next_scene(flags=0):
	if next_scenes.empty():
		print("SceneLoader: No scene available to load! Ignoring.")
		return false

	var background = bool(flags & BACKGROUND)
	var priority   = bool(flags & HIGH_PRIORITY)

	# Are we doing foreground?
	if not background && is_hidden():
		show()
		get_tree().get_current_scene().queue_free()

	# Let ThreadLoader start working (prioritize if not running in background)
	ThreadLoader.queue_resource(next_scenes.front(), priority)
	return true

# Unloads current scene (if requested) and loads the one in the given path
func show_scene(path, halt_current = false):
	var scene = null # Reference to the scene to show

	# Instance the loaded scene and put it ahead all the others
	var res = ThreadLoader.get_resource(path)
	if halt_current: # Halt current scene (if issued)
		get_tree().change_scene_to(res)
		scene = get_tree().get_current_scene()
	else:
		var name = get_filename_from(path)
		if !KHR2.has_node(name):
			# Instancing and adding to tree
			scene = res.instance()
			KHR2.add_child(scene)

			# Setting scene up
			scene.set_filename(path)
			scene.set_name(name)
		else:
			print("SceneLoader: '", name, "' was already loaded! Ignoring.")

	next_scenes.erase(path)
	loaded_scenes.erase(path)
	return scene

# Loads the next available scene
func show_next_scene(halt_current = false):
	return show_scene(loaded_scenes.front(), halt_current)

# Erases the scene associated to the given path
func erase_scene(scene):
	if scene == null:
		return

	ThreadLoader.cancel_resource(scene.get_filename())
	scene.set_name("freeing")
	scene.queue_free()
