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

func goto_scene(path):
	Scenes.next = ResourceLoader.load_interactive(path)
	# Check if something went wrong
	# TODO: use an "if" condition and output our error.
	assert(Scenes.next != null)
	set_process(true)

	Scenes.current.queue_free()
	_do_animation(true)

	wait_frames = 1

func _process(delta):
	if Scenes.next == null:
		# no more loading
		set_process(false)
		return

	if wait_frames > 0:
		wait_frames -= 1
		return

	var margin = OS.get_ticks_msec()
	while OS.get_ticks_msec() < margin + MAX_TIME: # use "time_max" to control how much time we block this thread
		# poll your Scenes.next
		var err = Scenes.next.poll()

		if err == ERR_FILE_EOF: # load finished
			var resource = Scenes.next.get_resource()
			Scenes.next = null
			set_new_scene(resource)
			# On stop l'anim et on efface le sprite utilisé
			_do_animation(false)
			break
		elif err == OK:
			# Au cas si on veut mettre quelque chose à jour
			break
		else:
			# Si on est là, le chargement a aussi eu un problème...
			Scenes.next = null
			break

func set_new_scene(scene_resource):
	Scenes.current = scene_resource.instance()
	get_node("/root").add_child(Scenes.current)
