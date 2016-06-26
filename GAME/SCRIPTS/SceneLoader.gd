extends Node

# Constants
const PATH_SCENES = "res://GAME/SCENES/"
const MAX_TIME = 100 # msec
const MainLoader = preload(PATH_SCENES + "MainLoader.tscn")

# Instance members
var Scenes = {
	"current" : null,
	"next" : null,
	"loader" : null
}
var Loading = {
	"animation" : null,
	"sprite" : null
}

# Our FIFO Queue
var Queue = []

######################
### Core functions ###
######################
func _ready():
	var root = get_node("/root")
	# The last Node is the one currently being shown
	Scenes.current = root.get_child(root.get_child_count()-1)

func _prepare_main_loader():
	# Skip in case it's already instanced
	if Scenes.loader != null:
		return

	Scenes.loader = MainLoader.instance()

	# If a MainLoader is NOT instanced, then something REALLY went wrong
	assert(Scenes.loader != null)
	Loading.sprite = Scenes.loader.get_node("Heart")
	Loading.animation = Scenes.loader.get_node("HeartAnimation")
	get_node("/root").add_child(Scenes.loader)

func _destroy_main_loader():
	Scenes.loader.queue_free()
	get_node("/root").remove_child(Scenes.loader)
	Scenes.loader = null

func _do_animation(play):
	if play:
		Loading.animation.play("Rotation")
		Loading.sprite.set_opacity(1)
	else:
		Loading.animation.stop()
		Loading.sprite.set_opacity(0)

func _process(delta):
	if Scenes.next == null:
		# no more loading
		set_process(false)
		return

	var margin = OS.get_ticks_msec()
	while OS.get_ticks_msec() < margin + MAX_TIME: # use "MAX_TIME" to control how much time we block this thread
		# poll your next Scene
		var err = Scenes.next.poll()

		if err == ERR_FILE_EOF: # load finished
			var resource = Scenes.next.get_resource()
			Scenes.next = null
			Scenes.current = resource.instance()
			get_node("/root").add_child(Scenes.current)

			# We destroy the MainLoader since we don't need it anymore
			_destroy_main_loader()

			break
		elif err == OK:
			# Au cas si on veut mettre quelque chose à jour
			break
		else:
			# Loading error: probably some files weren't loaded.
			Scenes.next = null
			# FIXME: Quitting is too much; think of an alternative scenario in
			# FIXME: case of failure
			OS.alert("There was a problem loading the next scene.", "Loading error!")
			get_tree().quit()
			break

########################
### Helper functions ###
########################
static func _enqueue(queue, elem):
	assert(typeof(queue) == TYPE_ARRAY && elem != null)
	if elem in queue:
		print("queue already contains input element")
		return

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
		scene.queue_free()

###############
### Methods ###
###############
# Adds a scene's path to our queue
func add_scene(path):
	# Check if we were given a partial path
	if !path.is_abs_path():
		path = PATH_SCENES + path
	# Now, if it still doesn't fit in the description, don't enqueue it
	if path.is_abs_path():
		_enqueue(Queue, path)

# Determines if a scene can be loaded
func is_there_a_scene():
	return Queue.size() > 0

# Loads new scene using the MainLoader scene
func load_now():
	var new_scene = _dequeue(Queue)
	if new_scene == null:
		print("No scene available to load")
		return

	Scenes.next = _load_scene(new_scene)
	_stop_scene(Scenes.current)
	Scenes.current = null

	_prepare_main_loader()
	_do_animation(true)

	set_process(true)
