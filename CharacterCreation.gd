extends Node2D

# SCIENCE: Helps exploration, disease rates
# ENGINEERING: Helps repairs, fuel use
# TACTICAL: Helps with enemy attacks

onready var CrewNamesContainer = $CanvasLayer/MarginContainer/CenterContainer/VBoxContainer/CrewContainer/HBoxContainer/CrewNamesContainer
onready var CrewStationsContainer = $CanvasLayer/MarginContainer/CenterContainer/VBoxContainer/CrewContainer/HBoxContainer/CrewStations

var default_crew = [
	{
		"name": "Geordi LaForge",
		"station": "Engineering",
	},
	{
		"name": "Wesley Crusher",
		"station": "Science",
		"disease": null,
		"hours_sick": 0,
		"heals" : 0
	},
	{
		"name": "Nurse Ogawa",
		"station": "Science",
		"disease": null,
		"hours_sick": 0,
		"heals" : 0
	},
	{
		"name": "Tasha Yarr",
		"station": "Tactical",
		"disease": null,
		"hours_sick": 0,
		"heals" : 0
	},
	{
		"name": "Redshirt McGoo",
		"station" : "Engineering",
		"disease": null,
		"hours_sick": 0,
		"heals" : 0
	},
	{
		"name": "Kimmi Kang",
		"station" : "Tactical",
		"disease": null,
		"hours_sick": 0,
		"heals" : 0
	},
	
]

func _ready():
	randomize()
	# pre-populate crew and their stations
	var i = 0
	for n in CrewNamesContainer.get_children():
		var crew_choice = default_crew[randi() % default_crew.size()]
		var r_station = crew_choice.station #set station
		n.set_text(crew_choice.name) #set label text
		CrewStationsContainer.get_child(i).set_text(r_station)
		default_crew.erase(crew_choice)
		i += 1


func _on_Submit_pressed():
	#TODO: check for errors
	
	#save crew data to global
	var i = 0 
	var disease_names = GlobalData.DISEASES.keys()
	for n in CrewNamesContainer.get_children():
		#random disease for debugging
		#var disease_choice = GlobalData.DISEASES[disease_names[randi()%disease_names.size()]]
		GlobalData.CREW.push_front({ 
			"name": n.text, 
			"station":CrewStationsContainer.get_child(i).text,
			"disease": null,
			"hours_sick": 0,
			"heals" : 0
		})
		i += 1
	return get_tree().change_scene("res://Main.tscn")
