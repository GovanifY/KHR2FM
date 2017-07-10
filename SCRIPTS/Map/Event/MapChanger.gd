extends "MapEvent.gd"

# Collision object to grab area from
export(NodePath) var collision_node

onready var TouchArea = get_node("TouchArea")

func _ready():
	if collision_node == null:
		disconnect("body_enter", self, "_on_area_body_enter")
		print("MapChanger: No collision node found in order to map area!")
		return
	collision_node = get_node(collision_node)

	var polygon = collision_node.get_polygon()
	if polygon.size() <= 0:
		print("MapChanger: Polygon size is empty!")
		return

	TouchArea.get_shape().set_points(polygon)

func _on_area_body_enter(body):
	if body.is_type("MapPlayer") && not body.has_interacting(self):
		body.add_interacting(self)
		# XXX: Temporary code
		var path = "res://GAME/STORY/Intro/Aqua.tscn"
		SceneLoader.load_scene(path)
		SceneLoader.show_scene(path, true)
