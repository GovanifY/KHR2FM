extends Panel

# Important Nodes
onready var CommandBox = get_node("CommandBox")
onready var HistoryBox = get_node("HistoryBox")

# Instance members
var InputProcessing = []

######################
###    Functions   ###
######################
func _execute(input):
	#Basic thingy to return, have to be highly modded
	var script = GDScript.new()
	script.set_source_code("func run():\n\treturn " + input)
	script.reload()

	var obj = Reference.new()
	obj.set_script(script)

	return obj.run()

func _on_TextEdit_text_changed():
	var msg = CommandBox.get_text()
	if msg.empty():
		return
	if msg.find("\n") != -1:
		_update_history("> " + str(_execute(msg))+ "\n")
		CommandBox.set_text("")

func _update_history(result):
	HistoryBox.add_text(result)
