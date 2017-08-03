tool
extends Range

# Export values
export(NodePath) var background_polygon = NodePath("bg") setget set_bg_node
export(NodePath) var foreground_polygon = NodePath("fg") setget set_fg_node
export(int) var thickness = 20 setget set_thickness

# Constants
const BG_COLOR = Color(0.2, 0.2, 0.2) # Color for Background bar
const ARC_ANGLE = 270                 # Amount of arc to draw in degrees
const MAX_ARC_VALUE = 100             # Value representative of the arc
const NUM_POINTS = 24                 # Number of points to render the polygon

# Instance members
var bg # Background Polygon2D
var fg # Foreground Polygon2D

# "Private" members
var half_thickness

########################
### Export functions ###
########################
# Sets bg node
func set_bg_node(value):
	background_polygon = value
	update()

func set_fg_node(value):
	foreground_polygon = value
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
	reset_polygons()

	connect("changed", self, "_draw_both")
	connect("value_changed", self, "_draw_foreground")

# Overloading functions
func _draw():
	if get_tree().is_editor_hint():
		reset_polygons()
		_draw_both()

func _draw_progress_bar(polygon, value):
	if polygon == null:
		return # do nothing

	var radius = (int(min(get_size().x, get_size().y)) >> 1) - thickness
	var center = get_size() * 0.5

	var points = get_progress_bar(center, radius, value)
	if points != null && points.size() > 3:
		polygon.set_polygon(points)

func _draw_both(_=null):
	_draw_background()
	_draw_foreground()

func _draw_background():
	_draw_progress_bar(bg, get_max())

func _draw_foreground(value=get_value()):
	_draw_progress_bar(fg, value)

###############
### Methods ###
###############
func reset_polygons():
	if bg == null && has_node(background_polygon):
		bg = get_node(background_polygon)

	if fg == null && has_node(foreground_polygon):
		fg = get_node(foreground_polygon)
		fg.set_use_parent_material(true)

########################
### Helper functions ###
########################
# Gets complete polygon for our bar
func get_progress_bar(center, radius, value):
	var arc_amount = max(min(value, MAX_ARC_VALUE), 0)
	var points = get_circle_arc(center, radius, arc_amount)

	if value > MAX_ARC_VALUE:
		var rect_pos = get_rect_bar_position(center, radius-half_thickness)
		var rest_value = value - MAX_ARC_VALUE if value >= MAX_ARC_VALUE else 0

		# Additional points to avoid over-smoothing
		rect_pos.x -= rest_value + 2
		points.insert(NUM_POINTS+1, rect_pos)
		rect_pos.x -= 2
		points.insert(NUM_POINTS+1, rect_pos)

		# Adding leftmost points
		rect_pos.y += thickness
		points.insert(NUM_POINTS+1, rect_pos)
		rect_pos.x += 2
		points.insert(NUM_POINTS+1, rect_pos)

	return points

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

	var points_inner = Vector2Array()
	var points_outer = Vector2Array()

	var bar_inner = radius - half_thickness
	var bar_outer = radius + half_thickness
	var angle = (angle_to - angle_from)/NUM_POINTS

	for i in range(NUM_POINTS+1):
		var angle_point_outer = angle_from + i * angle
		var angle_point_inner = angle_from + (NUM_POINTS-i) * angle

		var position = center + Vector2( cos(deg2rad(angle_point_outer)), sin(deg2rad(angle_point_outer)) ) * bar_outer
		points_outer.push_back(position)

		position = center + Vector2( cos(deg2rad(angle_point_inner)), sin(deg2rad(angle_point_inner)) ) * bar_inner
		points_inner.push_back(position)

	return points_outer + points_inner
