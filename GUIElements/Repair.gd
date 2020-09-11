extends Control

var repair_cost = 0

func _ready():
	GlobalData.SECTOR_NAME = "Repairs"	
	repair_cost = ceil(GlobalData.REPAIR_COST)
	if EventFunctions.has_crew("Engineering"):
		repair_cost *= 0.5
	$MainContainer/CancelContainer/VBoxContainer/HBoxContainer/CostAmt.text = str(repair_cost)
	$MainContainer/CancelContainer/VBoxContainer/HBoxContainer2/TimeAmt.text = str(GlobalData.REPAIR_TIME)

func _process(_delta):
	check_fuel_cost()	
	
func check_fuel_cost():
	if repair_cost > GlobalData.FUEL:
		$MainContainer/ButtonContainer/ShieldsButton.set_disabled(true)
		$MainContainer/ButtonContainer/EnginesButton.set_disabled(true)
		$MainContainer/CancelContainer/VBoxContainer/HBoxContainer/CostAmt.set("custom_colors/font_color", Color("#ff0000"))
	if GlobalData.SHIELDS >= GlobalData.MAX_SHIELDS:
		$MainContainer/ButtonContainer/ShieldsButton.set_disabled(true)
	if GlobalData.ENGINE_EFFICIENCY >= 1:
		$MainContainer/ButtonContainer/EnginesButton.set_disabled(true)
		
func _on_ShieldsButton_pressed():
	GlobalData.FUEL -= repair_cost
	GlobalData.TIME += GlobalData.REPAIR_TIME
	GlobalData.SHIELDS += randi()%10+1

func _on_EnginesButton_pressed():
	GlobalData.FUEL -= repair_cost
	GlobalData.TIME += GlobalData.REPAIR_TIME
	GlobalData.ENGINE_EFFICIENCY += rand_range(0.1, 0.2)+0.5

func _on_Cancel_pressed():
	Globals.load_map()
