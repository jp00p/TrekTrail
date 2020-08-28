extends RemoteTransform2D

signal draw_line
export(NodePath) var Path
var base_speed = 0.0001
var moving = false
var timer = 0
var max_time = 0.05
onready var PlayerIcon = $"../../../PlayerIcon"

func _ready():
	var path = get_node(Path)
	path.unit_offset = GlobalData.PATH_OFFSET

func _process(delta):
	timer += delta
	if moving == false or GlobalData.PATH_OFFSET >= 1:
		return
	
	var speed = (GlobalData.WARP_SPEED*base_speed)
	var path = get_node(Path)
	GlobalData.PATH_OFFSET += speed
	path.unit_offset = GlobalData.PATH_OFFSET
	if timer >= max_time:
		GlobalData.line_points.append(PlayerIcon.position)
		timer -= max_time
