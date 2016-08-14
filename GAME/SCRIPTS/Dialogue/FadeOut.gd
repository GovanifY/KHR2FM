
extends Tween

signal finished()

func _ready():
	connect("tween_complete", self, "complete")
	connect("tween_step", self, "test")
	pass

func complete(object, key):
	emit_signal("finished")
	pass

func play(nodename):
	var node = get_node(nodename)
	interpolate_property(node, "visibility/opacity", 1, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	interpolate_property(node, "visibility/visible", true, false, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	cstart()
	pass
