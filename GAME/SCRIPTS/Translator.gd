# Instance members
var Lines

######################
### Core functions ###
######################
func _init(csv_path):
	var locale = TranslationServer.get_locale()
	Lines = Translation.new()
	Lines.set_locale(locale)

	var csv_file = File.new()
	csv_file.open(csv_path, csv_file.READ)

	# Iterating CSV lines
	var strarr = csv_file.get_csv_line()
	var locale_index = -1
	for id in range(strarr.size()):
		if strarr[id] == locale:
			locale_index = id

	while !csv_file.eof_reached():
		strarr = csv_file.get_csv_line()
		if 0 < locale_index && locale_index < strarr.size():
			Lines.add_message(strarr[0], strarr[locale_index])

	csv_file.close()
	csv_file = null

	# Adding translation to server
	TranslationServer.add_translation(Lines)

###############
### Methods ###
###############
func translate(lineID):
	return TranslationServer.translate(lineID)

func close():
	TranslationServer.remove_translation(Lines)
	Lines = null
