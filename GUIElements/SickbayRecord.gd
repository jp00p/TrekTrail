extends HBoxContainer
var crew_data
signal heal

func _process(delta):
	if crew_data == null:
		queue_free()
		return
	$CrewData/CrewName.text = crew_data.name
	$Icon.color = GlobalData.STATION_COLORS[crew_data.station]
	$Icon/Line2D.default_color = GlobalData.STATION_COLORS[crew_data.station]
	if crew_data.disease != null:
		$CrewData/CrewDiseaseName.text = crew_data.disease.name
		$Icon/CenterContainer/HealsRemaining.text = str(crew_data.disease.heals_required-crew_data.heals)
		$Icon/CenterContainer/HealsRemaining.set_visible(true)
		if crew_data.heals >= crew_data.disease.heals_required:
			crew_data.heals = 0
			crew_data.disease = null
	else:
		$CrewData/CrewDiseaseName.text = "Healthy"
		$Icon/CenterContainer/HealsRemaining.set_visible(false)


func _on_HealButton_pressed():
	if crew_data.disease != null:
		crew_data.heals += 1
		GlobalData.FUEL -= 1000
