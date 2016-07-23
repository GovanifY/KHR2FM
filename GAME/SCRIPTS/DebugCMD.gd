extends Node2D


func _ready():
	pass

func _execute(input):
	#Basic thingy to return, have to be highly modded
	var script = GDScript.new()
	script.set_source_code("func code():\n\treturn " + input)
	script.reload()

	var obj = Reference.new()
	obj.set_script(script)

	return obj.code()


func _on_TextEdit_text_changed():
	var msg = get_node("TextEdit").get_text()
	if msg == "":
		return
	if msg.find("\n\n") != -1:
		_execute(msg)
		get_node("TextEdit").set_text("")

