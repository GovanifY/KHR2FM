extends Node

# Constants
const PATH_SCENES = "res://GAME/SCENES/"
const MainLoader = preload("res://GAME/SCENES/MainLoader.tscn")
const ThreadLoader = preload("res://GAME/SCRIPTS/Loading/ThreadLoader.gd")

# Instance members
var Scenes = {
	"path" : null,
	"next" : null,
	"loader" : null
}
var Loading = {
	"length" : 0,
	"animation" : null,
	"sprite" : null,
	"background" : false,
	"complete" : true
}

# Our FIFO Queue
var Queue = []
# Our magical thread
var thread

######################
### Core functions ###
######################
func _prepare_main_loader():
	# Skip in case it's already instanced
	if Scenes.loader != null:
		return

	# Instance the loading scene
	Scenes.loader = MainLoader.instance()

	# If a MainLoader is NOT instanced, then something REALLY went wrong
	assert(Scenes.loader != null)
	# Grabbing important Loading data
	Loading.sprite = Scenes.loader.get_node("Heart")
	Loading.animation = Scenes.loader.get_node("HeartAnimation")
	Loading.length = Loading.animation.get_animation("Rotation").get_length()
	get_node("/root").add_child(Scenes.loader)

	# Start playing the animation
	_do_animation(true)

func _destroy_main_loader():
	_stop_scene(Scenes.loader)
	Scenes.loader = null

func _destroy_current_scene():
	# Grabbing the last root child, which, in our system, is the current scene
	var root = get_node("/root")
	_stop_scene(root.get_child(root.get_child_count()-1))

func _do_animation(play):
	if play:
		Loading.animation.play("Rotation")
		var step = randf() * Loading.length
		Loading.animation.seek(step)
	else:
		Loading.animation.stop()

func _set_new_scene():
	# We don't need the thread anymore
	kill_thread()
	# Instancing the new resource
	var resource = Scenes.next.get_resource()
	Scenes.next = null
	get_node("/root").add_child(resource.instance())

	Scenes.path = null

# Setup when loading was concluded
func _finish_loading():
	# Grabbing our latest result
	Scenes.next = thread.result()

	# We destroy the MainLoader since we don't need it anymore
	_destroy_main_loader()
	Loading.complete = true

	# Firing up the new scene
	if !Loading.background:
		_set_new_scene()


########################
### Helper functions ###
########################
static func _enqueue(queue, elem):
	assert(typeof(queue) == TYPE_ARRAY && elem != null)
	if not elem in queue:
		queue.push_back(elem)

static func _dequeue(queue):
	assert(typeof(queue) == TYPE_ARRAY)
	if queue.size() == 0:
		print("Queue is empty")
		return null

	# Since Godot doesn't know the definition of "pop", I have to do it this way
	var temp = queue[0]
	queue.pop_front()
	return temp

static func _load_scene(path):
	var next = ResourceLoader.load_interactive(path)
	# Check if something went wrong while loading the file
	# TODO: use an "if" condition and output our error.
	assert(next != null)
	return next

static func _stop_scene(scene):
	if scene != null:
		# Stop every process from the this node to avoid crashes
		scene.set_process(false)
		scene.set_process_input(false)
		scene.free()

###############
### Methods ###
###############
# Adds a scene's path to our queue
func add_scene(path):
	if !is_ready():
		return

	# Check if we were given a partial path
	if !path.is_abs_path():
		path = PATH_SCENES + path
	# Now, if it still doesn't fit in the description, don't enqueue it
	if path.is_abs_path():
		_enqueue(Queue, path)

# Determines if a scene can be loaded
func is_there_a_scene():
	return Queue.size() > 0

# Checks if a new scene is ready
func is_ready():
	var ret = Loading.complete
	if thread != null:
		ret = ret && !thread.is_active()
	return ret

# Loads new scene.
func load_new_scene(background = false):
	if !is_ready():
		return

	Scenes.path = _dequeue(Queue)
	if Scenes.path == null || Scenes.path.empty():
		print("SceneLoader: No available scene to load")
		return

	# Are we doing background?
	Loading.background = background
	if !background:
		_destroy_current_scene()
		_prepare_main_loader()

	# Manage the ThreadLoader with our material
	Loading.complete = false
	start_thread()

	return

# Fires up a new ThreadLoader
func start_thread():
	thread = ThreadLoader.new()
	thread.connect("scene_ready", self, "_finish_loading")
	thread.connect("scene_error", self, "kill_thread")
	thread.start_loader()
	thread.add_scene(_load_scene(Scenes.path))

# Kills thread and decrements RefCount
func kill_thread():
	if thread != null && thread.is_active():
		thread.wait_to_finish()
		thread.clear()

# Erases current scene and jumps over to the next one. There are two scenarios:
# 1. A scene is still loading, so it launches MainLoader
# 2. A scene is loaded, switch to it immediately
func next_scene():
	_destroy_current_scene()
	if !is_ready():
		_prepare_main_loader()

	thread.wait_to_finish()
	_destroy_main_loader()
	_set_new_scene()
	return
