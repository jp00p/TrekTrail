extends Control
var bg_pos = 0
var speed = 0.15
var vel = speed
onready var sounds = $beep

func _ready():
	randomize()
	sounds.stream.loop = false # don't loop the beeps
	AudioStreamManager.play("res://Sounds/A Fistful of Datas.ogg") # play the bg song
	
func _process(_delta):
	vel = lerp(vel, speed, 0.025)
	bg_pos += _delta + vel
	$SpaceBG.material.set_shader_param("x_offset", bg_pos) # scroll space

# start the game!
func _on_StartGame_pressed():
	sounds.play() # beep
	$AnimationPlayer.play("dissolve_start") # dissolve the text away
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://CharacterCreation.tscn") # switch to character creation

func _on_Timer_timeout():
	speed = rand_range(0.1, 1)
