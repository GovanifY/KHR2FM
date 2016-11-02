extends Node

# Instance members
var Lines

######################
### Core functions ###
######################
func _exit_tree():
	close()

###############
### Methods ###
###############
func init(csv_path = ""):
	# Checking arguments
	var proceed = true
	if typeof(csv_path) != TYPE_STRING:
		proceed = false
	elif csv_path.empty():
		proceed = false
	elif !(csv_path.is_rel_path() || csv_path.is_abs_path()) || !csv_path.ends_with(".csv"):
		proceed = false

	if !proceed:
		print("No CSV file set. Global lines will be loaded.")
		return false

	# Closing previous lines
	close()

	# Grabbing locale and locale_short version
	var locale = TranslationServer.get_locale()
	var locale_short = locale.split("_")[0]

	var csv_file = File.new()
	csv_file.open(csv_path, csv_file.READ)

	# Iterating CSV lines
	var strarr = Array(csv_file.get_csv_line())
	var locale_index = strarr.find(locale)

	# If the current locale wasn't found, try using locale_short
	if locale_index == -1:
		locale_index = strarr.find(locale_short)

		# If it still can't be found, falling back to "en"
		if locale_index == -1:
			locale = "en"
			locale_index = strarr.find(locale)

	Lines = Translation.new()
	Lines.set_locale(locale)

	while !csv_file.eof_reached():
		strarr = csv_file.get_csv_line()
		if 0 < locale_index && locale_index < strarr.size():
			Lines.add_message(strarr[0], strarr[locale_index])

	csv_file.close()

	# Adding translation to server
	TranslationServer.add_translation(Lines)
	return true

func translate(lineID):
	if Lines == null:
		tr(lineID)
	return TranslationServer.translate(lineID)

func close():
	if Lines != null:
		TranslationServer.remove_translation(Lines)
		Lines = null
