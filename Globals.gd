extends Node

func viewscreen_add_message(msg):
	var statuspanel = find_node_by_name(get_tree().get_root(), "ViewScreenContainer")
	if statuspanel != null:
		statuspanel.update_status_text(msg)

func hide_controls():
	var controls = find_node_by_name(get_tree().get_root(), "ControlsContainer")
	if controls:
		controls.hide()

func show_controls():
	var controls = find_node_by_name(get_tree().get_root(), "ControlsContainer")
	if controls:
		controls.show()
	
func viewscreen_load(path):
	var Screen = find_node_by_name(get_tree().get_root(), "ScreenHolder")
	var Scene = load(path)
	var scene = Scene.instance()
	for n in Screen.get_children():
		n.queue_free()
	Screen.add_child(scene)
	
func load_map():
	var Main = find_node_by_name(get_tree().get_root(), "Main")
	if Main:
		Main.alert("none")
		show_controls()
		viewscreen_load("res://Map.tscn")
	
func start_combat():
	GlobalData.SHIP_STATE = GlobalData.SHIP_STATES.SHIP_HUNTING
	hide_controls()
	
func stop_combat():
	GlobalData.SHIP_STATE = GlobalData.SHIP_STATES.SHIP_STOPPED
	show_controls()
		
func start_moving():
	if GlobalData.SHIP_STATE != GlobalData.SHIP_STATES.SHIP_MOVING:
		GlobalData.SHIP_STATE = GlobalData.SHIP_STATES.SHIP_MOVING

func stop_moving():
	if GlobalData.SHIP_STATE == GlobalData.SHIP_STATES.SHIP_MOVING:
		GlobalData.SHIP_STATE = GlobalData.SHIP_STATES.SHIP_STOPPED
		GlobalData.SPEED = 0
	
func find_node_by_name(root, name):
	if(root.get_name() == name): return root
	for child in root.get_children():
		if(child.get_name() == name):
			return child
		var found = find_node_by_name(child, name)
		if(found): return found
	return null
