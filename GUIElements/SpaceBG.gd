extends ColorRect

func _ready():
	material.set_shader_param("x_offset", randi()%1000)
	material.set_shader_param("nebcolor1", GlobalData.SECTOR_COLORS[GlobalData.CURRENT_SECTOR][0])
	material.set_shader_param("nebcolor2", GlobalData.SECTOR_COLORS[GlobalData.CURRENT_SECTOR][1])
