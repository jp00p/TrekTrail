extends Node2D

onready var viewscreen = $GUI/MarginContainer/VBoxContainer/HBoxContainer/ViewScreenContainer
onready var redalert1 = $GUI/MarginContainer/VBoxContainer/HBoxContainer/RedAlertIndicatorLeft/AnimationPlayer
onready var redalert2 = $GUI/MarginContainer/VBoxContainer/HBoxContainer/RedAlertIndicatorRight/AnimationPlayer
var toggle = 0
var tick_count = 0
var fuel_label

func _ready():
	pass

func _process(_delta):
	GlobalData.set_sector()
	# set up the colors lerping between sectors
	var next_color_1 = GlobalData.SECTOR_COLORS[GlobalData.CURRENT_SECTOR+1][0]
	var next_color_2 = GlobalData.SECTOR_COLORS[GlobalData.CURRENT_SECTOR+1][1]
	# current_path / (cur_sector_length+next_sector_length) ... WHEW
	var ratio = abs(GlobalData.PATH_OFFSET-GlobalData.SECTORS[GlobalData.CURRENT_SECTOR])/(GlobalData.SECTORS[GlobalData.CURRENT_SECTOR+1])
	GlobalData.CUR_SECTOR_COLOR1 = GlobalData.SECTOR_COLORS[GlobalData.CURRENT_SECTOR][0].linear_interpolate(next_color_1, ratio)
	GlobalData.CUR_SECTOR_COLOR2 = GlobalData.SECTOR_COLORS[GlobalData.CURRENT_SECTOR][1].linear_interpolate(next_color_2, ratio)

func alert(color):
	# displays the red alert animations
	if color == "red":
		redalert1.play("red_alert")
		redalert2.play("red_alert")
	
	if color == "none":
		redalert1.play("reset")
		redalert2.play("reset")

func timer_tick():
	#Global tick happens every tick regardless of moving
	if GlobalData.SHIP_STATE == GlobalData.SHIP_STATES.SHIP_MOVING:
		advance_time(1)
		ship_movement()
	if GlobalData.SHIP_STATE == GlobalData.SHIP_STATES.SHIP_EXPLORING:
		advance_time(1)
		ship_exploration()
		
func advance_time(val):
	# move time forward
	GlobalData.TIME += val
	handle_disease()

func ship_movement():
	# every movement tick, this happens
	#
	# use fuel
	# increase distance
	# reduce efficiency
	# tick exploration cooldown
	# show current sector name
	# roll for random events
	
	# engineering crew helps reduce engine wear
	if EventFunctions.has_crew("Engineering"):
		GlobalData.ENGINE_WEAR_MOD = 0.5
	else:
		GlobalData.ENGINE_WEAR_MOD = 1
		
	GlobalData.FUEL -= GlobalData.FUEL_USE
	GlobalData.DISTANCE_TRAVELLED = GlobalData.PATH_OFFSET*1000000
	GlobalData.ENGINE_EFFICIENCY -= (GlobalData.ENGINE_WEAR*GlobalData.ENGINE_WEAR_MOD)
	GlobalData.EXPLORATION_COOLDOWN -= 1
	roll_movement_event()



func handle_speed(val):
	# when a new speed is clicked...
	if val != "Cancel":
		GlobalData.WARP_SPEED = val
		viewscreen.update_status_text("Changing speed to [u]WARP "+val+"[/u]")
	Globals.load_map()


	
func start_exploration():
	#start the exploration process only if the cooldown is ready
	if GlobalData.EXPLORATION_COOLDOWN > 0:
		viewscreen.update_status_text("You have scanned this area already, you need to move " + str(GlobalData.EXPLORATION_COOLDOWN) + " more times before you can explore again.")
		return
	Globals.stop_moving()
	tick_count = 0
	viewscreen.viewscreen_load("res://GUIElements/Explore.tscn")
	GlobalData.SHIP_STATE = GlobalData.SHIP_STATES.SHIP_EXPLORING
	GlobalData.EXPLORATION_COOLDOWN = 25 #reset the exploration cooldown
	viewscreen.update_status_text("Now scanning local system. Do not engage warp engines or you'll corrupt the scan results!")

func start_moving():
	if GlobalData.SHIP_STATE != GlobalData.SHIP_STATES.SHIP_MOVING:
		GlobalData.SHIP_STATE = GlobalData.SHIP_STATES.SHIP_MOVING
		viewscreen.update_status_text("Engage warp engines!")
		Globals.load_map()
		Globals.start_moving()

func stop_moving():
	if GlobalData.SHIP_STATE == GlobalData.SHIP_STATES.SHIP_MOVING:
		GlobalData.SHIP_STATE = GlobalData.SHIP_STATES.SHIP_STOPPED
		GlobalData.SPEED = 0
		viewscreen.update_status_text("Full stop!")
		Globals.stop_moving()

func show_map():
	alert("none")
	if !viewscreen.has_node("Map"):
		viewscreen.viewscreen_load("res://Map.tscn")

func ship_exploration():
	#this runs every exploration tick
	#TODO: make good things happen sometimes
	#TODO: prevent controls while exploring...?
	if tick_count >= GlobalData.EXPLORATION_TICKS:
		#only explore for a certain number of ticks
		GlobalData.SHIP_STATE = GlobalData.SHIP_STATES.SHIP_STOPPED
		viewscreen.update_status_text("Scan complete!")
		Globals.load_map()
		return

	viewscreen.update_status_text("Scanning local system: PASS " + str(tick_count+1))
	var roll = randi() % 100
	tick_count += 1
	if roll <= (GlobalData.EXPLORATION_BASE_CHANCE + GlobalData.EXPLORATION_BONUS_CHANCE):
		roll = randi() % 100
		if roll <= 90:
			GlobalData.FUEL += randi() % 100
			viewscreen.update_status_text("You found some [color=#0f0]dilithium crystals![/color]")
		elif roll > 90:
			GlobalData.TORPEDOS += 1
			viewscreen.update_status_text("You found a random [rainbow]photon torpedo[/rainbow] floating around in space!")
		



func roll_movement_event():
	#random events that can happen per movement tick	

	# major events
	if (randi()%100) <= GlobalData.MAJOR_EVENT_CHANCE: 
		Globals.stop_moving()
		#TODO: load random event based on sector
		var pick_event = randi() % EventData.EVENTS.size()
		viewscreen.viewscreen_load_event(EventData.EVENTS[pick_event])
		alert("red")
		return
	
	#minor events
	elif (randi()%100) <= GlobalData.MINOR_EVENT_CHANCE:
		print("rolling random minor event")
		var mroll = randi()%100
		#warp speed increases the chances a microasteroid will hit
		if mroll <= 86:
			if GlobalData.CREW.size() >= 1:
				viewscreen.update_status_text("[color=gray]"+
					GlobalData.CREW[randi()%GlobalData.CREW.size()].name + " " +
					Babble.generate_technobabble() + ".[/color]"
				)
		else:
			viewscreen.update_status_text("A micro-asteroid hit the ship!")
		return




# handling diseases while travelling
func handle_disease():
	for c in GlobalData.CREW:
		if c.disease != null:
			print("DISEASE REPORT FOR " + c.name)
			print("CURRENT DISEASE " + c.disease.name)
			
			var deadliness = c.disease.deadliness
			var recovery_rate = c.disease.recovery_rate
			var death_roll = randf()
			var recover_roll = randf()
			
			print("BASE DEADLINESS/RECOVERY: " + str(deadliness) + "/" + str(recovery_rate))
			
			if EventFunctions.has_crew("Science"):
				#reduce deadliness and increase recovery if we have science crew
				deadliness *= 0.5
				recovery_rate *= 1.5
				print("MODIFIED DEADLINESS/RECOVERY: " + str(deadliness) + "/" + str(recovery_rate))
			
			print("DEATH/RECOVER ROLL: " + str(death_roll) + "/" + str(recover_roll))
			
			if recover_roll <= recovery_rate:
				#recovery takes precedence over death
				viewscreen.update_status_text("[color=#00ff00]"+c.name + " has recovered from " + c.disease.name+"[/color]")
				c.disease = null
			if death_roll <= deadliness and c.disease != null:
				viewscreen.update_status_text("[color=#990000]"+c.name+" has succumbed to " + c.disease.name + "![/color]")
				GlobalData.CREW.erase(c)
		else:
			#no disease, check if they get one!
			#TODO: base on sector, tweak rate
			if randi()%100 <= 2:
				var disease_names = GlobalData.DISEASES.keys()
				var infected_crew = c
				var infection = GlobalData.DISEASES[disease_names[randi()%disease_names.size()]]
				infected_crew.disease = infection
				viewscreen.update_status_text("[u]"+ infected_crew.name + "[/u] just contracted a disease: [color=red]" + infection.name + "[/color]")



# connections to signals

func _on_ControlsContainer_explore():
	# start exploration...
	start_exploration()

func _on_ControlsContainer_set_speed():
	# show speed settings
	Globals.stop_moving()
	viewscreen.viewscreen_load("res://GUIElements/WarpControls.tscn")

func _on_ControlsContainer_go():
	# Begin ship movement
	Globals.start_moving()
	Globals.load_map()

func _on_ControlsContainer_stop():
	# stop ship movement
	Globals.stop_moving()
	Globals.load_map()

func _on_ControlsContainer_sickbay():
	# sickbay button
	Globals.stop_moving()
	viewscreen.viewscreen_set_title("Sickbay")
	viewscreen.update_status_text("Reporting to sick bay")
	viewscreen.viewscreen_load("res://GUIElements/Sickbay.tscn")

func _on_ControlsContainer_repair():
	# repair button
	Globals.stop_moving()
	viewscreen.viewscreen_set_title("Repair")
	viewscreen.viewscreen_load("res://GUIElements/Repair.tscn")

func _on_ControlsContainer_rations():
	# rations button
	Globals.stop_moving()
	viewscreen.viewscreen_set_title("Set Ration Levels")
	viewscreen.viewscreen_load("res://GUIElements/Rations.tscn")

func _on_ViewScreenContainer_alert(alert_type):
	#receiving alert signal from the viewscreen
	alert(alert_type)
