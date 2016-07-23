extends Node2D


func _ready():
	pass

func execute(input):
	#Basic thingy to return, have to be highly modded
	var script = GDScript.new()
	script.set_source_code("func code():\n\treturn " + input)
	script.reload()

	var obj = Reference.new()
	obj.set_script(script)

	return obj.code()

