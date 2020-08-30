extends Control

signal speed_selection(speed)

func _ready():
	GlobalData.SECTOR_NAME = "Warp Speed Controls"
	for n in $GridContainer.get_children():
		if n.text.replace("WARP", "") != "Cancel":
			n.connect("pressed", self, "handle_speed_selection", [n.text])
		
func handle_speed_selection(val):
	var speed = val.replace("WARP ", "")
	GlobalData.WARP_SPEED = int(speed)
	Globals.load_map()


func _on_Cancel_pressed():
	Globals.load_map()
