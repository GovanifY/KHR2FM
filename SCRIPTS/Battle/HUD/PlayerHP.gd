tool
extends Range

# Export values
export(bool) var centered = false setget set_centered
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
# Centers the bar based on either upper-left-most side or at the center of this canvas
func set_centered(value):
	centered = value
	update()

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
	var center = Vector2() if not centered else get_size() * 0.5

	# Draw background, then progress
	_draw_round_bar(center, radius, BG_COLOR, get_max())
	_draw_round_bar(center, radius, color, get_value())

# Draws our bar
func _draw_round_bar(center, radius, color, value):
	var arc_value = max(min(value, MAX_ARC_VALUE), 0)
	var rect_pos = draw_circle_arc(center, radius, 270, color, arc_value)

	if value > MAX_ARC_VALUE:
		var rest_value = value - MAX_ARC_VALUE if value >= MAX_ARC_VALUE else 0
		rect_pos.y -= thickness
		draw_rect(Rect2(rect_pos, Vector2(-rest_value, thickness)), color)

	return rect_pos

########################
### Helper functions ###
########################
func draw_circle_arc(center, radius, maximum, color, amount):
	maximum = max(min(maximum, 360), 0)
	var angle_from = -180
	var angle_to = maximum * amount / MAX_ARC_VALUE + angle_from

	if angle_from >= angle_to:
		return

	var position
	var nb_points = 32
	var points_inner = Vector2Array()
	var points_outer = Vector2Array()

	var bar_inner = Vector2(1, 1) * (radius - half_thickness)
	var bar_outer = Vector2(1, 1) * (radius + half_thickness)
	var angle = (angle_to - angle_from)/nb_points

	for i in range(nb_points+1):
		var angle_point_outer = angle_from + i * angle
		var angle_point_inner = angle_from + (nb_points-i) * angle

		position = center + Vector2( cos(deg2rad(angle_point_outer)), sin(deg2rad(angle_point_outer)) ) * bar_outer
		points_outer.push_back(position)

		var new_pos = center + Vector2( cos(deg2rad(angle_point_inner)), sin(deg2rad(angle_point_inner)) ) * bar_inner
		points_inner.push_back(new_pos)

	draw_colored_polygon(points_outer + points_inner, color)
	return position
