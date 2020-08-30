extends Control

var repair_cost = 0

func _ready():
	GlobalData.SECTOR_NAME = "Repairs"
	repair_cost = ceil(GlobalData.REPAIR_COST * GlobalData.REPAIR_COST_MOD)
	$MainContainer/CancelContainer/HBoxContainer/CostAmt.text = str(repair_cost)

func _process(_delta):
	check_fuel_cost()	
	
func check_fuel_cost():
	if repair_cost > GlobalData.FUEL:
		$MainContainer/ButtonContainer/ShieldsButton.set_disabled(true)
		$MainContainer/ButtonContainer/EnginesButton.set_disabled(true)
		$MainContainer/CancelContainer/HBoxContainer/CostAmt.set("custom_colors/font_color", Color("#ff0000"))
		
func _on_ShieldsButton_pressed():
	GlobalData.FUEL -= repair_cost
	GlobalData.SHIELDS += randi()%10+1

func _on_EnginesButton_pressed():
	pass # Replace with function body.

func _on_Cancel_pressed():
	Globals.load_map()
