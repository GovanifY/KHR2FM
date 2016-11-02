extends VideoPlayer

# Ce script est dédié à la Scene Cinema qui sera un container pour quelque
# video que l'on veut jouer. Cela évitera la répétition de création de Scenes ou
# Scripts spécifiques à une certaine scène

# Export values
export(String, FILE, "tscn") var next_scene = ""
export(bool) var have_subtitles = false
export(String, FILE, "srt") var subtitles_file = ""
export(String, FILE, "csv") var csv_file = ""

# Instance members
onready var Translator = get_node("Translator")
onready var Subtitles  = {
	"label" : get_node("Subtitles"), # Node where the text should reside
	"array" : [],    # Array of 3-cell Arrays: 0->ON timer, 1->OFF timer, 2-> subtitle
	"index" : 0,
	"shown" : false  # showing the current subtitle
}

######################
### Core functions ###
######################
func _ready():
	# Parsing subtitles (if any)
	if have_subtitles:
		_parse_subtitles()

	# Loading next scene in the background (or instantly if there's no video)
	SceneLoader.add_scene(next_scene)
	SceneLoader.load_new_scene(get_stream() != null)

	# Start playing
	set_process(get_stream() != null)

func _process(delta):
	# Write subtitles
	if have_subtitles:
		var cur_pos = get_stream_pos()

		if Subtitles.array[Subtitles.index][0] < cur_pos && cur_pos < Subtitles.array[Subtitles.index][1]:
			if !Subtitles.shown:
				Subtitles.label.set_text(Subtitles.array[Subtitles.index][2])
				Subtitles.shown = true

		elif cur_pos >= Subtitles.array[Subtitles.index][1]:
			Subtitles.label.set_text("")
			Subtitles.shown = false
			Subtitles.index += 1
			# To avoid going out of bounds
			if Subtitles.index >= Subtitles.array.size():
				have_subtitles = false

	# FIXME: Still no VideoStream.finished() signal? This needs to exist
	if !is_playing():
		SceneLoader.next_scene()
	return

func _parse_subtitles():
	var subs = File.new()

	if !subs.file_exists(subtitles_file) || !subs.file_exists(csv_file):
		print("Cinema: Cannot add subtitles. Check if you added the subtitles and CSV files.")
		return

	# I tried to make this as performant as possible, but it's still not enough.

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
	Translator.init(csv_file)

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
