extends Node2D

var timer = 0.3
var time_limit = 0.3

func _draw():
	if GlobalData.line_points.size() > 2:
		draw_polyline(GlobalData.line_points, Color(1, 0, 0, 0.6), 4)
	
func _process(delta):
	timer += delta
	if(timer >= time_limit):
		update()
		timer -= time_limit
