extends VBoxContainer

onready var Timer = $TypingTimer
onready var Status = $StatusPanel/StatusUpdates
onready var Screen = $ViewScreen/ScreenHolder

var strings = [
	"Welcome to the [wave]final[/wave] frontier. [rainbow]SPACE!!![/rainbow]"
]

var message_queue = []

var status_updating = false

func _ready():
	viewscreen_load("res://Map.tscn")
	viewscreen_set_title(GlobalData.SECTOR_NAME)
	update_status_text(strings[0])

func _process(_delta):
	# always show the current current "sector name" (can also be an event title)
	viewscreen_set_title(GlobalData.SECTOR_NAME)

func viewscreen_set_title(title):
	# set the viewscreen title
	$ViewScreenTitle.text = str(title)

func viewscreen_load(path):
	# load a scene into the viewscreen
	var Scene = load(path)
	var scene = Scene.instance()
	for n in Screen.get_children():
		n.queue_free()
	Screen.add_child(scene)
	
func viewscreen_load_event(event):
	# load an event scene into the viewscreen
	# connect the event's button signals
	update_status_text(event.text)
	GlobalData.SECTOR_NAME = event.title
	var EventScene = load("res://GUIElements/Event.tscn")
	var event_scene = EventScene.instance()
	event_scene.connect("choice1", self, "handle_event_choice")
	event_scene.connect("choice2", self, "handle_event_choice")
	event_scene.event_data = event  
	for n in Screen.get_children():
		n.queue_free()
	Screen.add_child(event_scene)

func update_status_text( string_text ):
	# update the scrolling status text
	if string_text == null:
		return	
	Status.append_bbcode(string_text)
	Status.newline()
	
func start_ship_movement():
	# start the map movement
	var map = $ViewScreen/ScreenHolder/Map
	map.move_start()

func stop_ship_movement():
	# stop the map movement
	var map = $ViewScreen/ScreenHolder/Map
	map.move_stop()	

func handle_event_choice(result, result_text):
	#`result` is an array of function,argument
	#`result_text` is what should appear after the result is processed
	
	var consequence #will hold the resulting consequence text, if any
	if result.size() > 1:
		#call event function with argument
		consequence = EventFunctions.call(result[0].replace(' ', '_').to_lower(), result[1])
	else:
		#call event function no args
		consequence = EventFunctions.call(result[0].replace(' ', '_').to_lower())
	
	if result_text != "":
		update_status_text(result_text)
	if consequence != "":
		update_status_text(consequence)
