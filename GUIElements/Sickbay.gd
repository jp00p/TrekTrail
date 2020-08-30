extends Control

onready var records = $CrewRecords

func _ready():
	GlobalData.SECTOR_NAME = "Sick Bay"
	for c in GlobalData.CREW:
		var Record = load("res://GUIElements/SickbayRecord.tscn")
		var record = Record.instance()
		record.crew_data = c
		records.add_child(record)

func _on_HealAll_pressed():
	for c in GlobalData.CREW:
		if c.disease != null:
			c.heals += 1
			if c.heals >= c.disease.heals_required:
				c.disease = null


func _on_CancelButton_pressed():
	Globals.load_map()
