extends Node

# Instance members
var Lines

###############
### Methods ###
###############
func init(csv_path):
	var csv_file = File.new()

	# Checking arguments
	if (typeof(csv_path) != TYPE_STRING || csv_path.empty()
	|| !csv_file.file_exists(csv_path)):
		print("Translator: No CSV file set. Global lines will be loaded.")
		return false

	csv_file.open(csv_path, csv_file.READ) #####################################

	# Grabbing locale and locale_short version
	var strarr = Array(csv_file.get_csv_line())

	var locale = TranslationServer.get_locale()
	var locale_short = locale.split("_")[0]
	var locale_index = strarr.find(locale)

	# If the `locale` wasn't found, try using locale_short
	if locale_index == -1:
		locale_index = strarr.find(locale_short)

		# If `locale_short` wasn't found, fall back to "en"
		if locale_index == -1:
			locale = "en"
			locale_index = strarr.find(locale)

	# Setting new Lines
	close()
	Lines = Translation.new()
	Lines.set_locale(locale)

	# Iterating CSV lines
	while !csv_file.eof_reached():
		strarr = csv_file.get_csv_line()
		if 0 < locale_index && locale_index < strarr.size():
			Lines.add_message(strarr[0], strarr[locale_index])

	csv_file.close() ###########################################################

	# Adding translation to server
	TranslationServer.add_translation(Lines)
	return true

func close():
	if Lines != null:
		TranslationServer.remove_translation(Lines)
		Lines = null
