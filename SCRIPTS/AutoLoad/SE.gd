extends SamplePlayer


######################
### Core functions ###
######################
func _ready():
	# Grabbing saved volume
	var volume
	if !KHR2.config.has_section_key("sound", "volume"):
		volume = get_default_volume()
	else:
		volume = KHR2.config.get_value("sound", "volume")
	set_default_volume(volume)

func set_default_volume(value):
	KHR2.config.set_value("sound", "volume", value)
	AS.set_fx_global_volume_scale(value)
