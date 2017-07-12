extends Panel

# Instance members
onready var Subsettings = get_node("Subsettings")

######################
### Core functions ###
######################
func _exit_tree():
	Music.stop()

func _ready():
	# Connecting sliders to respective objects
	Subsettings.get_node("Music").connect("changed", Music, "set_current_volume")
	Subsettings.get_node("Sound").connect("changed", self, "_se_changed")

	# XXX: Test music
	Music.set_stream(preload("res://ASSETS/BGM/Dearly_Beloved.ogg"))
	Music.play()

# Specific setting changers (require more than just one-liners)
func _se_changed(value):
	SE.set_default_volume(value)
	SE.play("system_selected")
