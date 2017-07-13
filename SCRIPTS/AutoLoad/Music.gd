extends StreamPlayer

# Signals
signal end_fade

# Constants
const VOL_MAX  = 1.0
const VOL_HIGH = 0.75
const VOL_MED  = 0.5
const VOL_LOW  = 0.25
const VOL_MUTE = 0.0

# Fader control
onready var Fader = Tween.new()

######################
### Core functions ###
######################
func _ready():
	# Grabbing saved volume
	var volume
	if !KHR2.config.has_section_key("music", "volume"):
		volume = VOL_MAX
	else:
		volume = get_current_volume()
	set_current_volume(volume)

	# Setting up Fader
	add_child(Fader)
	Fader.set_name("Fade")
	Fader.connect("tween_complete", self, "_on_end_fade")

	# Finishing touches
	set_loop(true)

#######################
### Signal routines ###
#######################
func _on_end_fade(object, key):
	if (get_volume() == VOL_MUTE):
		stop()
		set_volume(get_current_volume())
	emit_signal("end_fade")

###############
### Methods ###
###############
# Volume control
func get_current_volume():
	return KHR2.config.get_value("music", "volume")

func set_current_volume(value):
	KHR2.config.set_value("music", "volume", value)
	set_volume(value)

# Fading methods
func fade(time, vol_in, vol_out):
	Fader.interpolate_method(
		self, "set_volume",
		vol_in, vol_out, time,
		Fader.TRANS_LINEAR, Fader.EASE_IN_OUT
	)
	Fader.start()

func fade_in(time):
	fade(time, VOL_MUTE, get_current_volume())

func fade_out(time):
	fade(time, get_current_volume(), VOL_MUTE)
