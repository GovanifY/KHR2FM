extends SamplePlayer


######################
### Core functions ###
######################
func _ready():
	# Grabbing saved volume
	if !KHR2.config.has_section_key("sound", "volume"):
		set_default_volume(get_default_volume())
	else:
		set_default_volume(KHR2.config.get_value("sound", "volume"))

func set_default_volume(value):
	.set_default_volume(value)
	KHR2.config.set_value("sound", "volume", value)
