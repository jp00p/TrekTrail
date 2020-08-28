extends Control

signal hunting_ended
onready var phasers = $Phasers
onready var shot_timer = $ShotTimer
onready var shot_progress = $ShotProgress
var offset = 0
var scroll_dirs = [-1, 1]
var scroll_dir
var scroll_speed
var points
var phaser_start = Vector2(156,262) #starting location of player phasers
var can_shoot = true
var cursor_image = preload("res://ShootingGame/cursor.png")
var base_time = 1
var damage_effect_timer = 0


func _ready():
	randomize()
	
	# shooty cursor!
	Input.set_custom_mouse_cursor(cursor_image,
			Input.CURSOR_ARROW,
			Vector2(32, 32))
	scroll_speed = 1
	scroll_dir = scroll_dirs[randi()%scroll_dirs.size()]
	
	#
	# if there are any TACTICAL crew members, 
	# our phaser timer is reduced by half
	#
	if EventFunctions.has_crew("Tactical"):
		base_time = 0.5
	
	shot_timer.wait_time = base_time


func _process(delta):
	if GlobalData.FUEL > 0:
		shot_progress.value = 100 - (shot_timer.time_left/base_time*100)
	offset += scroll_dir
	$ColorRect.material.set_shader_param("x_offset", offset*scroll_speed)
	
	if damage_effect_timer > 0:
		# show an effect when you're hit
		damage_effect_timer -= 1
		$ScreenEffect.material.set_shader_param("aberration_amount", randi()%10)
	else:
		$ScreenEffect.material.set_shader_param("aberration_amount", 0)


func _input(event):
	# handle mouse clicking
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed and can_shoot:
				can_shoot = false
				shot_timer.start()
				var point = get_local_mouse_position()
				create_laser(point)
				print(phasers.points)
				yield(get_tree().create_timer(0.075), "timeout")
				# clear phasers right after fired
				phasers.remove_point(1)
				for c in $Phasers/StaticBody2D.get_children():
					c.queue_free();


func _on_ShipTimer_timeout():
	spawn_enemy_ship()

func spawn_enemy_ship():
	# spawn an enemy ship
	# TODO: Load different enemy types
	var Enemy = load("res://ShootingGame/EnemyShip.tscn")
	var enemy = Enemy.instance()
	enemy.target = phasers.get_point_position(0)
	enemy.connect("enemy_escaped", self, "shield_damage")
	$Enemies.add_child(enemy)

func create_laser(point):
	# create the laser effect
	if GlobalData.FUEL <= 0:
		return
	GlobalData.FUEL -= 10
	phasers.remove_point(1)
	phasers.add_point(point)
	var phaser_angle = phaser_start.angle_to_point(point)
	var s = create_segment(phaser_start, point)
	$Phasers/StaticBody2D.add_child(s)

func create_segment(p1,p2):
	# create the collision box for the laser
	var collision = CollisionShape2D.new()
	collision.shape = SegmentShape2D.new()
	collision.shape.a = p1
	collision.shape.b = p2
	collision.shape.connect("body_entered", self, "enemy_hit")
	return collision

func _on_ShotTimer_timeout():
	shot_timer.stop()
	can_shoot = true

func shield_damage():
	GlobalData.SHIELDS -= 10
	damage_effect_timer = 10	

func _on_GameTimer_timeout():
	emit_signal("hunting_ended")
	Globals.load_map()
	Input.set_custom_mouse_cursor(null,
			Input.CURSOR_ARROW,
			Vector2(32, 32))
	queue_free()