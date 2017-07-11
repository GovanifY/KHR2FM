extends "MapEvent.gd"

# ID lines (or text)
export(StringArray) var lines

# Member variables
var path_dialogue = "res://SCENES/Dialogue/Dialogue.tscn"

func _interacted():
	if lines == null:
		return

	if Globals.get("Dialogue") == null:
		var player = Globals.get("Map").player
		player.stop()

		SceneLoader.load_scene(path_dialogue, SceneLoader.BACKGROUND)
		var Dialogue = SceneLoader.show_scene(path_dialogue)
		Dialogue.connect("hide", SceneLoader, "erase_scene", [Dialogue])

		# Writing NPC's lines
		Dialogue.show(true)
		yield(Dialogue.Bubble, "shown")

		for line in lines:
			Dialogue.write(line)
			yield(Dialogue, "finished")

		Dialogue.hide()
		player.start()
