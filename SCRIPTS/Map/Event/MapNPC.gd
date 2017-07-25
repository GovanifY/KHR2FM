extends "MapEvent.gd"

# ID lines (or text)
export(String, FILE, "csv") var csv_path
export(Vector2) var lines_idx = Vector2()

const Avatar = preload("res://addons/avatar/Avatar.gd")

# Member variables
var path_dialogue = "res://SCENES/Dialogue/Dialogue.tscn"

func _interacted():
	if csv_path == null:
		return

	if !KHR2.has_node("Dialogue"):
		Translator.set_csv(csv_path)

		var player = KHR2.get("Map").player
		player.stop()

		SceneLoader.load_scene(path_dialogue, SceneLoader.BACKGROUND)
		var Dialogue = SceneLoader.show_scene(path_dialogue)
		Dialogue.connect("hide", SceneLoader, "erase_scene", [Dialogue])

		# Writing NPC's lines
		Dialogue.speak(Avatar.new("NPC"), lines_idx.x, lines_idx.y)
		yield(Dialogue, "finished")

		Translator.close()
		Dialogue.close()
		player.start()
