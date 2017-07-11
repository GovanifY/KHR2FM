extends "MapEvent.gd"

# Export vars
export(String, FILE, "tscn") var next_location

######################
### Core functions ###
######################
func _ready():
	var collision_node
	for node in get_children():
		if node.is_type("CollisionPolygon2D"):
			collision_node = node
			break

	if collision_node == null:
		disconnect("body_enter", self, "_on_area_body_enter")
		print("MapChanger: No CollisionPolygon2D child node found in order to map area!")
		return

	var polygon = collision_node.get_polygon()
	if polygon.size() <= 0:
		print("MapChanger: Collision polygon size is empty!")
		return

	get_node("TouchArea").get_shape().set_points(polygon)

func _player_touched():
	SceneLoader.load_scene(next_location)
