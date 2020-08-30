extends Node

func has_crew(station): # check if station exists in crew
						# stations don't stack!
						# diseased crew members don't count
	for c in GlobalData.CREW:
		if str(c.station) == str(station) and c.disease == null:
			return true
	return false
	
func combat(enemy_type, custom_message=""):
	Globals.start_combat()
	Globals.viewscreen_load("res://ShootingGame.tscn")
	if custom_message == "":
		return "Engaging the " + str(enemy_type)
	else:
		return custom_message.format(enemy_type)
	
func torpedos(enemy_type):
	GlobalData.PATH_OFFSET -= rand_range(0.01, GlobalData.PATH_OFFSET)
	Globals.load_map()
	return
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

func shield_loss():
	var shield_loss = randi() % 30
	if has_crew("Engineering"):
		shield_loss = ceil(shield_loss/2)
		GlobalData.SHIELDS -= shield_loss
		return "Your engineering crew quickly recalibrates the shield harmonics. You only lost " + str(shield_loss) + " shields!"
	GlobalData.SHIELDS -= shield_loss
	return "You lost " + str(shield_loss) + " shields!"

func nothing():
	return "Default action: Nothing happens"

func lose_time():
	pass
