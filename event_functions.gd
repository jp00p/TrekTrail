extends Node

func has_crew(station): # check if station exists in crew
						# stations don't stack!
	for c in GlobalData.CREW:
		if str(c.station) == str(station):
			return true
	return false
	
func combat(enemy_type):
	Globals.viewscreen_load("res://ShootingGame.tscn")
	return "Engaging the " + str(enemy_type)
	
func torpedos(enemy_type):
	if GlobalData.TORPEDOS < 2:
		Globals.viewscreen_load("res://ShootingGame.tscn")
		return "You don't have enough torpedos! Engaging the enemy in close combat!"
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
