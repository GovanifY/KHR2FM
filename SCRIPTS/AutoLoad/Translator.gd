extends Node

# Instance members
var lines

func _exit_tree():
	close()

###############
### Methods ###
###############
func set_csv(csv_path):
	if csv_path == null:
		print("Translator: No CSV file set. Global lines will be loaded.")
		return false

	var csv_file = File.new()

	# Checking arguments
	if (typeof(csv_path) != TYPE_STRING || csv_path.empty()
	|| !csv_file.file_exists(csv_path)):
		return false

	csv_file.open(csv_path, csv_file.READ) #####################################

	# Grabbing locale and locale_short version
	var strarr = Array(csv_file.get_csv_line())

	var locale = TS.get_locale()
	var locale_short = locale.split("_")[0]
	var locale_index = strarr.find(locale)

	# If the `locale` wasn't found, try using locale_short
	if locale_index == -1:
		locale_index = strarr.find(locale_short)

		# If `locale_short` wasn't found, fall back to "en"
		if locale_index == -1:
			locale = "en"
			locale_index = strarr.find(locale)

	# Setting new lines
	close()
	lines = Translation.new()
	lines.set_locale(locale)

	# Iterating CSV lines
	while !csv_file.eof_reached():
		strarr = csv_file.get_csv_line()
		if 0 < locale_index && locale_index < strarr.size():
			lines.add_message(strarr[0], strarr[locale_index])

	csv_file.close() ###########################################################

	# Adding translation to server
	TS.add_translation(lines)
	return true

func close():
	if lines != null:
		TS.remove_translation(lines)
		lines = null
