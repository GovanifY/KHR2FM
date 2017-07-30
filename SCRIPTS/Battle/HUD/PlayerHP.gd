#tool # FIXME: THIS WORKS POORLY; FIX IT, GODOT TEAM
extends CanvasItem

# Export values
export(bool) var centered = false setget set_centered
export(int) var radius = 0 setget set_radius
export(int) var thickness = 1 setget set_thickness

export(Color, RGB) var color = Color() setget set_color

#export(Range)

# "Private" members
var center = get_pos() if not centered else get_size() / 2

######################
### Core functions ###
######################
### Export functions
# Centers the bar based on either upper-left-most side or at the center of this canvas
func set_centered(value):
	centered = value
	center = get_pos() if not centered else get_size() / 2
	update()

# Sets the radius of the round bar
func set_radius(value):
	radius = value
	update()

# Sets the bar color
func set_color(value):
	color = value
	update()

# Sets thickness of the bar (cannot be bigger than radius)
func set_thickness(value):
	thickness = value if value < radius else radius
	update()

# Overloading functions
func _draw():
	# Let us draw this whole thing from scratch
	draw_circle_part(center, radius, color)
	#draw_circle_part(center, radius, Color())

func draw_circle_part(center, radius, color):
	var angle_from = -180
	var angle_to   = 90
	thickness *= Vector2(0.5, 0.5)

	# Drawing a round ProgressBar
	var nb_points = 32
	var points_arc = Vector2Array()
	points_arc.push_back(center)
	var color_border = Color() # FIXME
	var colors = ColorArray([color])

	for i in range(nb_points+1):
		var angle_point = angle_from + i * (angle_to - angle_from)/nb_points
		points_arc.push_back(center + Vector2( cos(deg2rad(angle_point)), sin(deg2rad(angle_point)) ) * radius)
	draw_polygon(points_arc, colors)
