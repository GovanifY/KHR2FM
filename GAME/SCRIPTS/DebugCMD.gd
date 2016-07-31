extends CanvasLayer

# Important Nodes
onready var CommandBox = get_node("Panel/CommandBox")
onready var HistoryBox = get_node("Panel/HistoryBox")

# Instance members
var HistoryList = {
	"idx"  : -1,
	"cmds" : []
}

######################
### Core functions ###
######################
func _ready():
	CommandBox.set_wrap(false)

# Executes a small script with the given input
func _execute(input):
	var script = GDScript.new()
	script.set_source_code("func run():\n\treturn " + str(input) + "\n")
	script.reload()

	var obj = Reference.new()
	obj.set_script(script)

	return obj.run()

func _command_process():
	var cmd = _clean_cmd()

	# Executing and saving to History
	HistoryBox.add_text("> " + str(_execute(cmd)) + "\n")
	if not (cmd in HistoryList.cmds):
		HistoryList.cmds.push_back(cmd)
		_last_cmd()

	CommandBox.clear_undo_history()
	CommandBox.set_text("")

func _clean_cmd():
	# Clearing the Return-turned-newline oddity
	var lin = CommandBox.cursor_get_line() - 1
	var col = CommandBox.get_line(lin).length()
	CommandBox.select(lin, col, lin+1, 0)
	CommandBox.insert_text_at_cursor("")

	return CommandBox.get_text()

func _last_cmd():
	HistoryList.idx = HistoryList.cmds.size() - 1

func _point_to_end(idx):
	CommandBox.cursor_set_line(CommandBox.get_line_count())
	CommandBox.cursor_set_column(idx)

#######################
### Signal routines ###
#######################
func _CommandBox_input(event):
	var size = HistoryList.cmds.size()

	if event.is_pressed() && !event.is_echo():
		# Controlling Returns
		if event.is_action("ui_accept"):
			_command_process()
			_last_cmd()
			return

		# Controlling HistoryList
		var up = event.is_action("ui_up")
		var down = event.is_action("ui_down")

		if up || down:
			if 0 <= HistoryList.idx && HistoryList.idx < size:
				var text = HistoryList.cmds[HistoryList.idx]
				CommandBox.set_text(text)
				_point_to_end(text.length())
			else:
				CommandBox.set_text("")

		if up && HistoryList.idx > 0:
			HistoryList.idx -= 1
		elif down && HistoryList.idx < size - 1:
			HistoryList.idx += 1
