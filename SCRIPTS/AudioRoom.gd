extends StreamPlayer

var audio_placeholder

# Core functions
func _ready():
	set_loop(true)

# Methods
func load_music(node):
	# Free old one, if any
	if audio_placeholder != null:
		audio_placeholder.free()

	audio_placeholder = node.duplicate()
	set_stream(audio_placeholder.get_stream())
	return
