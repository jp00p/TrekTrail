extends Control

func _ready():
	randomize()
	$ColorRect.material.set_shader_param("x_offset", randi()%1000)
