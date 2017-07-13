extends Panel

# Instance members
onready var Subsettings = get_node("Subsettings")
onready var fullscreen = Subsettings.get_node("Fullscreen")

######################
### Core functions ###
######################
func _exit_tree():
	Music.stop()

func _ready():
	# Connecting sliders to respective objects
	Subsettings.get_node("Music").connect("changed", Music, "set_current_volume")
	Subsettings.get_node("Sound").connect("changed", self, "_se_changed")
	fullscreen.connect("pressed", self, "_fullscreen_pressed", [true])

	# Setting buttons up
	_fullscreen_pressed(false)

	# XXX: Test music
	Music.set_stream(preload("res://ASSETS/BGM/Dearly_Beloved.ogg"))
	Music.play()

# Specific setting changers (require more than just one-liners)
func _se_changed(value):
	SE.set_default_volume(value)
	SE.play("system_selected")

func _fullscreen_pressed(pressed):
	var on = KHR2.fullscreen() if pressed else OS.is_window_fullscreen()
	fullscreen.set_text(tr("SETTINGS_FULLSCREEN") + " " +
		tr("ON" if on else "OFF")
	)
