extends Node2D

# Ce script est dédié à la Scene Cinema qui sera un container pour quelque
# video que l'on veut jouer. Cela évitera la répétition de création de Scenes ou
# Scripts spécifiques à une certaine scène

# Export values
export(VideoStreamTheora) var video_file = null
export(String, FILE, "*.tscn") var next_scene = ""

# Instance members
var Video = {
	"playing" : false,
	"node" : null
}

# Core functions
func _process(delta):
	if !Video.playing:
		Video.node.play()
		Video.playing = true
	else:
		# FIXME: This is horrible in terms of performance. Look for an alternative
		if !Video.node.is_playing():
			# TODO: don't do this immediately
			get_node("/root/SceneLoader").goto_scene(next_scene)
	return

func _enter_tree():
	# Initial checks
	assert(video_file != null)
	assert(next_scene.get_file())

func _ready():
	# Setting video file
	Video.node = get_node("Video")
	Video.node.set_stream(video_file)

	# Start playing
	set_process(true)
