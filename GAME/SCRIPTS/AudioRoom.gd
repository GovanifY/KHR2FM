extends StreamPlayer

# Core functions
func _ready():
	set_loop(true)

# Methods
func load_music(node):
	set_stream(node.get_stream())
	return
