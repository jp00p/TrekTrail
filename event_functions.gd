extends Node

func has_crew(station): # check if station exists in crew
						# stations don't stack!
						# diseased crew members don't count
	for c in GlobalData.CREW:
		if str(c.station) == str(station) and c.disease == null:
			return true
	return false
	
func combat(enemy_type):
	Globals.start_combat()
	Globals.viewscreen_load("res://ShootingGame.tscn")
	return "Engaging the " + str(enemy_type).capitalize()
	
func torpedos(enemy_type):
	if GlobalData.TORPEDOS < 2:
		combat(enemy_type)
		return "You don't have enough torpedos! You'll have to engage the %s in close combat!" % enemy_type	
	else:
		Globals.load_map()
		GlobalData.TORPEDOS -= 2
		return "Firing torpedos!"
	
func lose_crew_member():
	if GlobalData.CREW.size() > 0:
		var lost_member = GlobalData.CREW.pop_front()
		return "[shake]"+lost_member.name + " has been lost![/shake]"
	else:
		return "You have no crew to lose! There's a silver lining in every dark nebula."
	
func shield_loss_minor():
	var shield_loss = randi()%5+5
	if has_crew("Engineering"):
		shield_loss = ceil(shield_loss/2)
	GlobalData.SHIELDS -= shield_loss
	Globals.load_map()
	return "Your shields lost [color=aqua]" + str(shield_loss) + "%[/color] power."
	
func shield_gain_minor():
	var shield_gain = randi()%5+5
	if has_crew("Engineering"):
		shield_gain = floor(shield_gain*2)
	GlobalData.SHIELDS += shield_gain
	Globals.load_map()
	return "You gain [color=aqua]" + str(shield_gain) + "%[/color] shield power."
	
func time_loss_minor():
	var time_loss = randi()%3+3
	GlobalData.TIME += time_loss
	Globals.load_map()
	return "Your actions have cost you " + str(time_loss) + " hours."
	
func distance_loss_minor():
	var offset_loss = rand_range(0.025, 0.035)
	var distance_loss = offset_loss*1000000
	GlobalData.PATH_OFFSET -= offset_loss
	GlobalData.DISTANCE_TRAVELLED -= distance_loss
	Globals.load_map()
	return "You lost " + str(distance_loss) + " number of units. Path offset loss: " + str(floor(offset_loss))
	
func nothing():
	return "Default action: Nothing happens"

func lose_time():
	pass
