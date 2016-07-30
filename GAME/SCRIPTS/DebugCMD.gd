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
	var cmd = CommandBox.get_text()
	cmd = _clean_str(cmd)

	# Executing and saving to History
	HistoryBox.add_text("> " + str(_execute(cmd)) + "\n")
	if not (cmd in HistoryList.cmds):
		HistoryList.cmds.push_back(cmd)
		HistoryList.idx = HistoryList.cmds.size() - 1

	CommandBox.clear_undo_history()
	CommandBox.set_text("")

func _clean_str(string):
	string = string.strip_edges()
	string = string.replace("\n", "")
	return string

func _point_to_end(idx):
	#CommandBox.cursor_set_line(CommandBox.get_line_count())
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
