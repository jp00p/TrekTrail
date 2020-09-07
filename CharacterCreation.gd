extends Node2D

# SCIENCE: Helps exploration, disease rates
# ENGINEERING: Helps repairs, fuel use
# TACTICAL: Helps with enemy attacks

onready var CrewNamesContainer = $CanvasLayer/MarginContainer/CenterContainer/VBoxContainer/CrewContainer/HBoxContainer/CrewNamesContainer
onready var CrewStationsContainer = $CanvasLayer/MarginContainer/CenterContainer/VBoxContainer/CrewContainer/HBoxContainer/CrewStations
onready var sounds = $AudioStreamPlayer2D
var bg_pos = 0

var default_crew = [
	{
		"name": "Geordi LaForge",
		"station": "Engineering",
	},
	{
		"name": "Wesley Crusher",
		"station": "Science",
	},
	{
		"name": "Nurse Ogawa",
		"station": "Science",
	},
	{
		"name": "Tasha Yarr",
		"station": "Tactical",
	},
	{
		"name": "Redshirt McGoo",
		"station" : "Engineering",
	},
	{
		"name": "Kimmi Kang",
		"station" : "Tactical",
	},
	
]

func _ready():
	randomize()
	sounds.stream.loop = false
	# pre-populate crew and their stations
	var i = 0
	for n in CrewNamesContainer.get_children():
		var crew_choice = default_crew[randi() % default_crew.size()]
		var r_station = crew_choice.station #set station
		n.set_text(crew_choice.name) #set label text
		CrewStationsContainer.get_child(i).set_text(r_station)
		CrewStationsContainer.get_child(i).set_station_color()
		default_crew.erase(crew_choice)
		i += 1


func _process(_delta):
	bg_pos += _delta
	$CanvasLayer/SpaceBG.material.set_shader_param("x_offset", bg_pos)

func _on_Submit_pressed():
	#TODO: check for errors
	
	#save crew data to global
	var i = 0 
	var _disease_names = GlobalData.DISEASES.keys()
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


func _on_ShieldsConfButton_pressed():
	sounds.play()
	GlobalData.CONFERENCE = "Shields"


func _on_TacticsConfButton_pressed():
	sounds.play()
	GlobalData.CONFERENCE = "Tactics"


func _on_MedicalConfButton_pressed():
	sounds.play()
	GlobalData.CONFERENCE = "Medical"


func _on_EnginesConfButton_pressed():
	sounds.play()
	GlobalData.CONFERENCE = "Engines"
