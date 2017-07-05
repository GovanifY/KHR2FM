extends StreamPlayer

# Signals
signal end_fade

# Constants
const VOL_MAX  = 1
const VOL_HIGH = 0.75
const VOL_MED  = 0.5
const VOL_LOW  = 0.25
const VOL_MUTE = 0

# Regulated volume
var VOL_NORMAL = VOL_MAX

# Fader control
onready var Fader = Tween.new()

######################
### Core functions ###
######################
func _ready():
	# Setting up Fader
	add_child(Fader)
	Fader.connect("tween_complete", self, "_on_end_fade")

	# Finishing touches
	set_loop(true)

#######################
### Signal routines ###
#######################
func _on_end_fade(object, key):
	if (get_volume() == VOL_MUTE):
		stop()
		set_volume(VOL_NORMAL)
	emit_signal("end_fade")

###############
### Methods ###
###############
# Volume control
func regulate_volume(value):
	VOL_NORMAL = value
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
	fade(time, VOL_MUTE, VOL_NORMAL)

func fade_out(time):
	fade(time, VOL_NORMAL, VOL_MUTE)
