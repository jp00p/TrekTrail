extends Control

signal speed_selection(speed)

func _ready():
	connect("speed_selection", get_tree().get_root().get_node("Main"), "handle_speed")
	for n in $GridContainer.get_children():
		n.connect("pressed", self, "handle_speed_selection", [n.text])
		
func handle_speed_selection(val):
	val = val.replace("WARP ", "")
	emit_signal("speed_selection", val)
	queue_free()
