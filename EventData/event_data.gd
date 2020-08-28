extends Node

var EVENTS = {}

func _ready():
	#load events from json file
	EVENTS = get_from_json("res://EventData/events.json")
	print(EVENTS)

func get_from_json(filename):  
	var file = File.new()
	file.open(filename, File.READ)  
	var text= file.get_as_text()  
	var data= parse_json(text)  
	file.close()
	return data 
