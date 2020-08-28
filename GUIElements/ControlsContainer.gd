extends VBoxContainer

signal go
signal stop
signal set_speed
signal explore
signal sickbay
signal repair
signal rations

onready var sb_button = $SickbayButton

func _ready():
	if randi() % 10 == 1:
		sb_button.text = "Sicks Bay"

func hide():
	#$AnimationPlayer.play("hide")
	#yield($AnimationPlayer, "animation_finished")
	for c in get_children():
		if c is Control:
			c.set_disabled(true)
		
func show():
	#$AnimationPlayer.play_backwards("hide")
	for c in get_children():
		if c is Control:
			c.set_disabled(false)
	
func _on_GoButton_pressed():
	emit_signal("go")

func _on_StopButton_pressed():
	emit_signal("stop")

func _on_SetSpeedButton_pressed():
	emit_signal("set_speed")

func _on_ExploreButton_pressed():
	emit_signal("explore")

func _on_SickbayButton_pressed():
	emit_signal("sickbay")
	
func _on_RepairButton_pressed():
	emit_signal("repair")

func _on_SetRationsButton_pressed():
	emit_signal("rations")
