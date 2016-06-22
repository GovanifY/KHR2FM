extends Node2D

# Ce script est dédié à la Scene Cinema qui sera un container pour quelque
# video que l'on veut jouer. Cela évitera la répétition de création de Scenes ou
# Scripts spécifiques à une certaine scène

# Export values
export(VideoStreamTheora) var video_file = null
export(String, FILE, "*.tscn") var next_scene = ""
export(bool) var have_subtitles = false
export(String, FILE, "*.srt") var subtitles_file = ""

# Instance members
var Video = {
	"playing" : false,
	"node" : null
}

var Subtitles = {
	"array" : [],    # Array of 3-cell Arrays: 0->ON timer, 1->OFF timer, 2-> subtitle
	"index" : 0,     # index of the array
	"shown" : false, # showing the current subtitle
	"label" : null   # Node where the text should reside
}

# Core functions
func _process(delta):
	if !Video.playing:
		Video.node.play()
		Video.playing = true
	else:
		# Write subtitles
		if have_subtitles:
			var cur_pos = Video.node.get_stream_pos()

			if Subtitles.array[Subtitles.index][0] < cur_pos && cur_pos < Subtitles.array[Subtitles.index][1]:
				if !Subtitles.shown:
					Subtitles.label.set_bbcode(apply_effects(Subtitles.array[Subtitles.index][2]))
					Subtitles.shown = true

			elif cur_pos >= Subtitles.array[Subtitles.index][1]:
				Subtitles.label.clear()
				Subtitles.shown = false
				Subtitles.index += 1
				# To avoid going out of bounds
				if Subtitles.index >= Subtitles.array.size():
					have_subtitles = false

		# FIXME: This is horrible in terms of performance. Look for an alternative
		if !Video.node.is_playing():
			# TODO: don't goto_scene() like this. Update SceneLoader to have better
			# TODO: Scene handling
			get_node("/root/SceneLoader").goto_scene(next_scene)
	return

func _enter_tree():
	# Initial checks
	assert(video_file != null)
	assert(next_scene.get_file())

func _ready():
	# Setting video file
	Video.node = get_node("Video")
	Video.node.set_stream(video_file)

	# Setting subtitles (if any)
	Subtitles.label = get_node("Subtitles")
	parse_subtitles()

	# Start playing
	set_process(true)

# Misc.
static func apply_effects(string):
	return "[center]" + string + "[/center]"

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

func parse_subtitles():
	if have_subtitles || subtitles_file.empty():
		print("Current subtitle settings prohibit me from proceeding. Skipping.")

	assert(Subtitles.label != null)

	# All right, I tried to make this as performant as possible, but it's still
	# not fast enough. So, either I switch to static programming on this one, or I
	# let it be this slow.

	# Opening subs file
	var subs = File.new()
	subs.open(subtitles_file, File.READ)

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
			arr.push_back(tr(line)) # pushing text/translation

			# Pushing this array onto the main array
			Subtitles.array.push_back(arr)

	subs.close()