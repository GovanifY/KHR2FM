extends Control

# Constants
const PATH_SCENES  = "res://GAME/"

# Instance members
onready var ThreadLoader = preload("res://SCRIPTS/AutoLoad/Loading/ThreadLoader.gd").new(get_node("Progress"))
onready var Loading = {
	"animation"  : get_node("HeartAnimation"),
	"background" : false
}
var next_scenes = Array()
var loaded_scenes = Array()

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
	connect("draw", self, "set_process", [true])
	connect("hide", self, "set_process", [false])

func _process(delta):
	for scene in next_scenes:
		if ThreadLoader.is_ready(scene):
			show_scene(scene)
			next_scenes.erase(scene)

	# If we're done here, stop processing
	if next_scenes.empty():
		hide()

func _scene_was_loaded(path):
	loaded_scenes.push_back(path)

func _on_visibility_changed():
	KHR2.set_process_input(is_hidden())

########################
### Helper functions ###
########################
static func complete_path(path):
	# Check if we were given a partial path
	if !path.is_abs_path():
		path = PATH_SCENES + path
	return path

static func get_scene_name(path):
	path = path.get_file()
	path = path.replace(".tscn", "")
	return path

###############
### Methods ###
###############
# Adds the given resources to queue to load them immediately
func load_scene(path, background = false):
	path = complete_path(path)

	var f = File.new()
	if !f.file_exists(path):
		print("SceneLoader: Cannot load given path because it doesn't exist.")
		return false

	# Are we doing background?
	Loading.background = background
	if !background:
		show()
		get_tree().get_current_scene().queue_free()

		# Pushing an additional scene for loading in foreground
		next_scenes.push_back(path)

	# Let ThreadLoader start working (prioritize if not running in background)
	ThreadLoader.queue_resource(path, !background)
	return true

# Checks if any scene is ready to load
func is_ready():
	return !loaded_scenes.empty() && next_scenes.empty() && is_hidden()

# Unloads current scene and loads the currently loaded one
func show_scene(path, halt_current = false):
	path = complete_path(path)

	# Instance the loaded scene and put it ahead all the others
	var res = ThreadLoader.get_resource(path)
	if halt_current: # Halt current scene (if issued)
		get_tree().change_scene_to(res)
	else:
		root.add_child(res.instance())

	loaded_scenes.erase(path)
	return true

# Erases the scene associated to the given path
func erase_scene(path):
	ThreadLoader.cancel_resource(path)
	var name = get_scene_name(path)
	root.get_node(name).queue_free()

# Loads the next available scene
func next_scene(halt_current = false):
	show_scene(loaded_scenes.front(), halt_current)
