extends Control

func _ready():
	GlobalData.SECTOR_NAME = "Warp Speed Controls"
	for n in $GridContainer.get_children():
		if n.text.replace("WARP", "") != "Close":
			n.connect("pressed", self, "handle_speed_selection", [n.text])
			if int(n.text.replace("WARP", "")) == GlobalData.WARP_SPEED:
				n.pressed = true
		
func handle_speed_selection(val):
	var speed = val.replace("WARP ", "")
	GlobalData.WARP_SPEED = int(speed)
	Globals.load_map()


func _on_Cancel_pressed():
	Globals.load_map()
