extends VBoxContainer

onready var day = $Chronometer/DayContainer/DayAmt
onready var hour = $Chronometer/TimeContainer/TimeAmt
onready var shields = $Tactical/TacticalContainer/Gear/GearContainer/VBoxContainer/ShieldsAmt
onready var torpedos = $Tactical/TacticalContainer/Gear/GearContainer/VBoxContainer2/TorpedosAmt
onready var distance_remaining = $Tactical/TacticalContainer/Distance/DistancesContainer/DestinationContainer/DestinationAmt
onready var distance_travelled = $Tactical/TacticalContainer/Distance/DistancesContainer/DistanceContainer/DistanceAmt
onready var fuel = $WarpContainer/VBoxContainer/HBoxContainer/FuelAmt
onready var fuel_use = $WarpContainer/VBoxContainer/HBoxContainer/FuelUseAmt
onready var warp_speed = $WarpContainer/VBoxContainer/HBoxContainer/WarpSpeedAmt

onready var actual_speed = $WarpContainer/VBoxContainer/Engineering/SpeedAmt
onready var efficiency = $WarpContainer/VBoxContainer/Engineering/EfficiencyAmt

func _process(delta):
	day.text = str(GlobalData.DAYS_PASSED)
	hour.text = str(GlobalData.TIME_OF_DAY)
	shields.text = str(GlobalData.SHIELDS)
	torpedos.text = str(GlobalData.TORPEDOS)
	distance_travelled.text = str(GlobalData.DISTANCE_TRAVELLED)
	distance_remaining.text = str(GlobalData.DESTINATION - GlobalData.DISTANCE_TRAVELLED)
	fuel.text = str(GlobalData.FUEL)
	fuel_use.text = str(GlobalData.FUEL_USE)
	warp_speed.text = "WARP " + str(GlobalData.WARP_SPEED)
	efficiency.value = round(GlobalData.ENGINE_EFFICIENCY * 100)
	actual_speed.value = ceil(GlobalData.SPEED)
