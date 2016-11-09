extends Control

# Constants
const PATH_SCENES  = "res://GAME/"

# Instance members
onready var ThreadLoader = preload("res://SCRIPTS/Loading/ThreadLoader.gd").new()
onready var Loading = {
	"animation"  : get_node("HeartAnimation"),
	"background" : false
}
var current_scene
var next_scenes = Array()

# "Private" members
onready var root = get_tree().get_root()

######################
### Core functions ###
######################
func _show_screen():
	show()
	Loading.animation.set_active(true)
	set_process(true)

func _hide_screen():
	set_process(false)
	Loading.animation.set_active(false)
	hide()

func _process(delta):
	for scene in next_scenes:
		if is_ready(scene):
			show_scene(scene)
			next_scenes.erase(scene)

	# If we're done here, stop processing
	if next_scenes.empty():
		_hide_screen()

########################
### Helper functions ###
########################
static func complete_path(path):
	# Check if we were given a partial path
	if !path.is_abs_path():
		path = PATH_SCENES + path
	return path

static func halt_node(node):
	if typeof(node) == TYPE_OBJECT:
		# Stop every process from this node to avoid crashes
		node.set_process(false)
		node.set_process_input(false)
		node.set_fixed_process(false)
		node.queue_free()

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

	# Setting current scene (by grabbing root's last child)
	if current_scene == null:
		current_scene = root.get_child(root.get_child_count()-1)

	# Are we doing background?
	Loading.background = background
	if !background:
		_show_screen()
		halt_node(current_scene)
		current_scene = null

		# Pushing an additional scene for loading in foreground
		next_scenes.push_back(path)

	# Let ThreadLoader start working (prioritize if not running in background)
	Loading.complete = false
	ThreadLoader.queue_resource(path, !background)

	return true

# Checks if the given resource is ready
func is_ready(path):
	path = complete_path(path)
	return ThreadLoader.is_ready(path)

# Unloads current scene and loads the currently loaded one
func show_scene(path, halt_current = false):
	path = complete_path(path)

	# Halt current scene (if issued)
	if halt_current:
		halt_node(current_scene)
		current_scene = null

	# Instance the loaded scene and put it ahead all the others
	var resource = ThreadLoader.get_resource(path)
	root.add_child(resource.instance())

func erase_scene(path):
	ThreadLoader.cancel_resource(path)

# Kills all threads
func kill_all_threads():
	ThreadLoader.clear()
