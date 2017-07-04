extends Control

# Signals
signal scene_was_pushed
signal scene_was_loaded

# Flags
enum { BACKGROUND = 0x1, HIGH_PRIORITY = 0x2 }

# Instance members
onready var ThreadLoader = preload("res://SCRIPTS/AutoLoad/Loading/ThreadLoader.gd").new(get_node("Progress"))
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
	ThreadLoader.connect("finished", self, "_scene_was_loaded")
	connect("visibility_changed", self, "_on_visibility_changed")

func _process(delta):
	for scene in next_scenes:
		if ThreadLoader.is_ready(scene):
			show_scene(scene, true)

	# If we're done here, stop processing
	if get_tree().get_current_scene() != null:
		hide()

func _scene_was_loaded(path):
	loaded_scenes.push_back(path)
	emit_signal("scene_was_loaded")

func _on_visibility_changed():
	KHR2.set_process_input(is_hidden())
	set_process(!is_hidden())

########################
### Helper functions ###
########################
static func get_scene_name(path):
	return path.get_file().replace(".tscn", "")

###############
### Methods ###
###############
# Checks if any scene is loaded
func is_loaded():
	return loaded_scenes.size() > 0

func queue_scene(path):
	if path == null:
		print("SceneLoader: NULL path given!")
		return false

	var f = File.new()
	if !f.file_exists(path):
		print("SceneLoader: File not found:\n\t\"", path, "\"")
		return false

	# Pushing given scene as reference
	next_scenes.push_back(path)
	emit_signal("scene_was_pushed")
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
	if !background && is_hidden():
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
		scene = res.instance()
		root.add_child(scene)

	next_scenes.erase(path)
	loaded_scenes.erase(path)
	return scene

# Loads the next available scene
func show_next_scene(halt_current = false):
	return show_scene(loaded_scenes.front(), halt_current)

# Erases the scene associated to the given path
func erase_scene(path):
	if path == null: return
	if path.empty(): return

	ThreadLoader.cancel_resource(path)
	var node = root.get_node(get_scene_name(path))
	if node != null:
		node.queue_free()
