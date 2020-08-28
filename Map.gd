extends Control
onready var path = $Path2D.curve
onready var draw_timer = $Timer
onready var screen = $ScreenEffect
var pos 

var damage_effects = [
	[1, 5],
	[1, 4],
	[2, 3]
]

func _ready():
	GlobalData.PATH_LENGTH = floor(path.get_baked_length())

func _process(delta):
	if GlobalData.SHIP_STATE == GlobalData.SHIP_STATES.SHIP_MOVING:
		$MapBG.material.set_shader_param("x_offset", $Path2D/PathFollow2D.offset * GlobalData.WARP_SPEED)
		move_start()
	else:
		move_stop()
	
	if GlobalData.SHIELDS >= 85:
		screen.material.set_shader_param("aberration_amount", 0)
		screen.material.set_shader_param("aberration_speed", 0)
	if GlobalData.SHIELDS < 85 and GlobalData.SHIELDS >= 50:
		screen.material.set_shader_param("aberration_amount", damage_effects[0][0])
		screen.material.set_shader_param("aberration_speed", damage_effects[0][1])
	if GlobalData.SHIELDS < 50 and GlobalData.SHIELDS >= 25:
		screen.material.set_shader_param("aberration_amount", damage_effects[1][0])
		screen.material.set_shader_param("aberration_speed", damage_effects[1][1])
	if GlobalData.SHIELDS < 25:
		screen.material.set_shader_param("aberration_amount", damage_effects[2][0])
		screen.material.set_shader_param("aberration_speed", damage_effects[2][1])
		

func move_start():
	$Path2D/PathFollow2D/PlayerMapPosition.moving = true

func move_stop():
	$Path2D/PathFollow2D/PlayerMapPosition.moving = false
