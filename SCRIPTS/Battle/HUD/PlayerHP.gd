tool
extends Range

# Export values
export(bool) var centered = false setget set_centered
export(int) var radius = 0 setget set_radius
export(int) var thickness = 1 setget set_thickness

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

# Sets the radius of the round bar
func set_radius(value):
	radius = value
	update()

# Sets colors
func set_color(value):
	color = value
	update()

# Sets thickness of the bar (cannot be bigger than radius)
func set_thickness(value):
	var limit = int(radius) >> 1
	thickness = value if value < limit else limit
	half_thickness = thickness >> 1
	update()

######################
### Core functions ###
######################
# Overloading functions
func _draw():
	# Let us draw this whole thing from scratch
	var center = get_pos() if not centered else get_size() / 2

	# Draw background, then progress
	var hbar_pos = _draw_round_bar(center, Vector2(), BG_COLOR, get_max())
	_draw_round_bar(center, hbar_pos, color, get_value())

	# Draw centered blank space
	draw_circle(center, radius - half_thickness, Color()) # FIXME: use a transparent color

# Draws our bar
func _draw_round_bar(center, rect_pos, color, value):
	var arc_value = max(min(value, MAX_ARC_VALUE), 0)
	rect_pos = draw_circle_arc(center, radius + half_thickness, color, arc_value)

	if value > MAX_ARC_VALUE:
		var rest_value = value - MAX_ARC_VALUE if value >= MAX_ARC_VALUE else 0
		rect_pos.y -= thickness
		draw_rect(Rect2(rect_pos, Vector2(-rest_value, thickness)), color)

	return rect_pos

########################
### Helper functions ###
########################
func draw_circle_arc(center, radius, color, amount):
	var maximum = 270 # 3/4 of a circle
	var angle_from = -180
	var angle_to = maximum * amount / MAX_ARC_VALUE + angle_from

	if angle_from >= angle_to:
		return

	# Drawing a round ProgressBar
	var nb_points = 32
	var points_arc = Vector2Array()
	points_arc.push_back(center)
	var colors = ColorArray([color])

	var position
	for i in range(nb_points+1):
		var angle_point = angle_from + i * (angle_to - angle_from)/nb_points
		position = center + Vector2( cos(deg2rad(angle_point)), sin(deg2rad(angle_point)) ) * radius
		points_arc.push_back(position)
	draw_polygon(points_arc, colors)

	return position
