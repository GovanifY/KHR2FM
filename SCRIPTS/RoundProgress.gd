tool
extends Range

# Export values
export(int) var thickness = 20 setget set_thickness

export(Color, RGB) var color = Color(0, 1, 0) setget set_color

# Constants
const BG_COLOR = Color(0.2, 0.2, 0.2)
const MAX_ARC_VALUE = 100

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
# Overloading functions
func _draw():
	# Let us draw this whole thing from scratch
	var radius = (int(min(get_size().x, get_size().y)) >> 1) - thickness
	var center = get_size() * 0.5

	# Draw background, then progress
	_draw_round_bar(center, radius, BG_COLOR, get_max())
	_draw_round_bar(center, radius, color, get_value())

# Draws our bar
func _draw_round_bar(center, radius, color, value):
	var arc_amount = max(min(value, MAX_ARC_VALUE), 0)
	var points = get_circle_arc(center, radius, 270, arc_amount)
	draw_colored_polygon(points, color)

	if value > MAX_ARC_VALUE:
		var rect_pos = get_rect_bar_position(center, radius-half_thickness, 270)
		var rest_value = value - MAX_ARC_VALUE if value >= MAX_ARC_VALUE else 0
		draw_rect(Rect2(rect_pos, Vector2(-rest_value, thickness)), color)

########################
### Helper functions ###
########################
func get_rect_bar_position(center, radius, maximum):
	maximum = max(min(maximum, 360), 0)
	var angle_from = -180
	var angle_to = maximum + angle_from

	var position = center + Vector2( cos(deg2rad(angle_to)), sin(deg2rad(angle_to)) ) * radius
	return position

func get_circle_arc(center, radius, maximum, amount):
	maximum = max(min(maximum, 360), 0)
	var angle_from = -180
	var angle_to = maximum * amount / MAX_ARC_VALUE + angle_from

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
