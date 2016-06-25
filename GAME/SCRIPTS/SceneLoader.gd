extends Node

const MAX_TIME = 100 # msec
var wait_frames

var Scenes = {
	"current" : null,
	"next" : null,
	"loading" : null
}
var Loading = {
	"animation" : null,
	"sprite" : null
}

# Core functions
func _ready():
	var root = get_tree().get_root()
	Scenes.current = root.get_child(root.get_child_count()-1)
	Scenes.loading = get_node("/root/MainLoader")

	# If the loading Scene is NOT loaded, then something REALLY went wrong
	assert(Scenes.loading != null)
	Loading.sprite = Scenes.loading.get_node("Heart")
	Loading.animation = Scenes.loading.get_node("HeartAnimation")
	_do_animation(false)

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

	if wait_frames > 0:
		wait_frames -= 1
		return

	var margin = OS.get_ticks_msec()
	while OS.get_ticks_msec() < margin + MAX_TIME: # use "MAX_TIME" to control how much time we block this thread
		# poll your next Scene
		var err = Scenes.next.poll()

		if err == ERR_FILE_EOF: # load finished
			var resource = Scenes.next.get_resource()
			Scenes.next = null
			_set_new_scene(resource)
			# On stop l'anim et on efface le sprite utilisé
			_do_animation(false)
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

func _set_new_scene(scene_resource):
	Scenes.current = scene_resource.instance()
	get_node("/root").add_child(Scenes.current)

# Methods
func goto_scene(path):
	Scenes.next = ResourceLoader.load_interactive(path)
	# Check if something went wrong
	# TODO: use an "if" condition and output our error.
	assert(Scenes.next != null)

	if Scenes.current != null:
		# Stop every process from the current node to avoid crashes
		Scenes.current.set_process(false)
		Scenes.current.set_process_input(false)
		Scenes.current.queue_free()
		Scenes.current = null
	_do_animation(true)

	wait_frames = 1
	set_process(true)
