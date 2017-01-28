extends StreamPlayer

# Core functions
func _ready():
	set_loop(true)

# Methods
func load_music(node):
	stop()
	set_stream(node.get_stream())
	return
