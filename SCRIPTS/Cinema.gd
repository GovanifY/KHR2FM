extends VideoPlayer

# Export values
export(String, FILE, "tscn") var next_scene = ""
export(String, FILE, "srt") var subtitles_file = ""
export(String, FILE, "csv") var translation_file = ""

# Instance members
onready var Subtitles = {
	"label" : get_node("Subtitles"), # Node where we keep our text
	"array" : [],                    # Array of 3-cell arrays (more info below)
	"index" : 0,                     # Index of the subtitles array
	"on"    : false,                 # Boolean that enables the usage of subtitles
}

######################
### Core functions ###
######################
func _enter_tree():
	KHR2.set_pause(preload("res://SCENES/Pause/CutscenePause.tscn"))
	KHR2.connect("toggled_pause", self, "_toggled_pause")

func _exit_tree():
	KHR2.set_pause(null)

func _ready():
	# Parsing subtitles (if any)
	_parse_subtitles()

	# Loading next scene in the background
	SceneLoader.load_scene(next_scene, SceneLoader.BACKGROUND)

	# Start playing
	set_process(get_stream() != null)

func _process(delta):
	# Write subtitles
	if Subtitles.on && Subtitles.index < Subtitles.array.size():
		var cur_pos = get_stream_pos()
		var sub_begin = Subtitles.array[Subtitles.index][0] # ON timer
		var sub_end   = Subtitles.array[Subtitles.index][1] # OFF timer
		var sub_text  = Subtitles.array[Subtitles.index][2] # text

		# If subtitles timer is on track
		if sub_begin < cur_pos && cur_pos < sub_end:
			if !Subtitles.label.is_visible():
				Subtitles.label.set_text(sub_text)
				Subtitles.label.show()

		# If subtitles timer is off track
		elif cur_pos >= sub_end:
			Subtitles.index += 1
			Subtitles.label.set_text("")
			Subtitles.label.hide()

	if !is_playing():
		SceneLoader.show_scene(next_scene, true)

func _parse_subtitles():
	# Check for subtitle files
	var subs = File.new()
	Subtitles.on = subs.file_exists(subtitles_file) && subs.file_exists(translation_file)
	if !Subtitles.on:
		return

	subs.open(subtitles_file, File.READ) #######################################
	while !subs.eof_reached():
		var line = subs.get_line()
		if !line.empty():
			var arr = []
			# Get next line to get timers
			var timers = subs.get_csv_line(" ")
			# timers is divided into 3: timer1, -->, timer2
			arr.push_back(timer_to_seconds(timers[0])) # pushing the ON timer
			arr.push_back(timer_to_seconds(timers[2])) # pushing the OFF timer

			# Get following line for the text/translation
			line = subs.get_line()
			arr.push_back(line) # pushing text/translation

			# Pushing this array onto the main array
			Subtitles.array.push_back(arr)

	subs.close() ###############################################################

	# Opening translation
	Translator.set_csv(translation_file)

#######################
### Signal routines ###
#######################
func _toggled_pause():
	set_paused(get_tree().is_paused()) # Pausing stream

########################
### Helper functions ###
########################
static func timer_to_seconds(formatted):
	var temp = formatted.split(":")
	var hrs  = temp[0].to_int()
	var mins = temp[1].to_int()
	var secs = temp[2].replace(",", ".").to_float()

	var ret = 0.0
	# Using these conditions to avoid doing needless Maths, because GDscript.
	if hrs > 0:
		ret += hrs * 3600
	if mins > 0:
		ret += mins * 60
	ret += secs
	return ret
