extends Control

# Constants
const PATH_SCENES  = "res://GAME/"

# Instance members
onready var ThreadLoader = preload("res://SCRIPTS/AutoLoad/Loading/ThreadLoader.gd").new()
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
func _ready():
	ThreadLoader.connect("finished", self, "_scene_was_loaded")

func _process(delta):
	for scene in next_scenes:
		if is_ready(scene):
			show_scene(scene)
			next_scenes.erase(scene)

	# If we're done here, stop processing
	if next_scenes.empty():
		_hide_screen()

func _show_screen():
	show()
	set_process(true)

func _hide_screen():
	set_process(false)
	hide()

func _scene_was_loaded(path):
	loaded_scenes.push_back(path)

########################
### Helper functions ###
########################
static func complete_path(path):
	# Check if we were given a partial path
	if !path.is_abs_path():
		path = PATH_SCENES + path
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
		# Setting current scene
		get_tree().set_current_scene(root.get_child(root.get_child_count()-1))

		_show_screen()
		get_tree().get_current_scene().queue_free()

		# Pushing an additional scene for loading in foreground
		next_scenes.push_back(path)

	# Let ThreadLoader start working (prioritize if not running in background)
	ThreadLoader.queue_resource(path, !background)
	return true

# Checks if the given resource is ready
func is_ready(path):
	path = complete_path(path)
	return ThreadLoader.is_ready(path)

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

func erase_scene(path):
	ThreadLoader.cancel_resource(path)

func next_scene(halt_current = false):
	show_scene(loaded_scenes.front(), halt_current)

# Kills all threads
func kill_all_threads():
	ThreadLoader.clear()
