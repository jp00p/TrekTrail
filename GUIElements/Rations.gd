extends Control

onready var rations = $RationContainer/HBoxContainer/CenterContainer/RationDesc

func _ready():
	GlobalData.SECTOR_NAME = "Replicator Rations"

func _on_LowRations_pressed():
	GlobalData.RATIONS = GlobalData.RATION_LEVELS.LOW
	Globals.viewscreen_add_message("Rations set to low!")
	rations.text = "Low rations will use less fuel, but increase your chance of sickness."


func _on_NormalRations_pressed():
	GlobalData.RATIONS = GlobalData.RATION_LEVELS.NORMAL
	Globals.viewscreen_add_message("Rations set to normal!")
	rations.text = "Normal rations, normal fuel use, normal sickness chance."


func _on_HighRations_pressed():
	GlobalData.RATIONS = GlobalData.RATION_LEVELS.HIGH
	Globals.viewscreen_add_message("Rations set to high!")
	rations.text = "Fuel use will be very high, but the chances of getting sick drop to near zero."
	
