tool
extends Range

# Export values
export(int) var thickness = 20 setget set_thickness
export(Color, RGB) var color = Color(0, 1, 0) setget set_color

# Constants
const BG_COLOR = Color(0.2, 0.2, 0.2)
const ARC_ANGLE = 270
const MAX_ARC_VALUE = 100

# Instance members
var bg # Background Polygon2D
var fg # Foreground Polygon2D

# "Private" members
var half_thickness

########################
### Export functions ###
########################
# Sets colors
func set_color(value):
	color = value
	update()

# Sets thickness of the bar
func set_thickness(value):
	thickness = value
	half_thickness = thickness >> 1
	update()

######################
### Core functions ###
######################
func _ready():
	# Setting bars
	if bg == null:
		bg = Polygon2D.new()
		bg.set_color(BG_COLOR)
		bg.set_use_parent_material(true)
		add_child(bg)

	if fg == null:
		fg = Polygon2D.new()
		fg.set_color(color)
		fg.set_use_parent_material(true)
		add_child(fg)

# Overloading functions
func _draw():
	var radius = (int(min(get_size().x, get_size().y)) >> 1) - thickness
	var center = get_size() * 0.5

	# Draw background, then progress
	var points_bg = get_progress_bar(center, radius, get_max())
	var points_fg = get_progress_bar(center, radius, get_value())
	if points_bg != null:
		bg.set_polygon(points_bg)

	if points_fg != null:
		fg.set_polygon(points_fg)

# Gets complete polygon for our bar
func get_progress_bar(center, radius, value):
	var arc_amount = max(min(value, MAX_ARC_VALUE), 0)
	var points = get_circle_arc(center, radius, arc_amount)

	if value > MAX_ARC_VALUE:
		var rect_pos = get_rect_bar_position(center, radius-half_thickness)
		var rest_value = value - MAX_ARC_VALUE if value >= MAX_ARC_VALUE else 0

		rect_pos.x -= rest_value
		points.insert(33, rect_pos)
		rect_pos.y += thickness
		points.insert(33, rect_pos)

	return points

########################
### Helper functions ###
########################
func get_rect_bar_position(center, radius):
	var angle_from = -180
	var angle_to = ARC_ANGLE + angle_from

	var position = center + Vector2( cos(deg2rad(angle_to)), sin(deg2rad(angle_to)) ) * radius
	return position

func get_circle_arc(center, radius, amount):
	var angle_from = -180
	var angle_to = ARC_ANGLE * amount / MAX_ARC_VALUE + angle_from

	if angle_from >= angle_to:
		return

	var nb_points = 32
	var points_inner = Vector2Array()
	var points_outer = Vector2Array()

	var bar_inner = radius - half_thickness
	var bar_outer = radius + half_thickness
	var angle = (angle_to - angle_from)/nb_points

	for i in range(nb_points+1):
		var angle_point_outer = angle_from + i * angle
		var angle_point_inner = angle_from + (nb_points-i) * angle

		var position = center + Vector2( cos(deg2rad(angle_point_outer)), sin(deg2rad(angle_point_outer)) ) * bar_outer
		points_outer.push_back(position)

		position = center + Vector2( cos(deg2rad(angle_point_inner)), sin(deg2rad(angle_point_inner)) ) * bar_inner
		points_inner.push_back(position)

	return points_outer + points_inner
