extends Sprite

func _process(_delta):
	if GlobalData.SHIP_STATE == GlobalData.SHIP_STATES.SHIP_MOVING:
		$WarpTrail1.emitting = true
		$WarpTrail2.emitting = true
	else:
		$WarpTrail1.emitting = false
		$WarpTrail2.emitting = false
