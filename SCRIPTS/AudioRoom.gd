extends StreamPlayer

var current_audio

# Core functions
func _ready():
	set_loop(true)

# Methods
func load_music(node):
	# Free old one, if any
	if current_audio != null:
		current_audio.stop()
		current_audio.free()

	current_audio = node.duplicate()
	set_stream(current_audio.get_stream())
	return
