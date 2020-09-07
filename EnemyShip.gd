extends KinematicBody2D

signal enemy_escaped

var directions = [-1, 1] # which way it can face
var h_speed = 0
var v_speed = 0
var direction = 1
var velocity = Vector2()
var spawn_y = rand_range(15,200) # range where it can spawn on the y axis
var dead = false
var target = Vector2()

export(int) var freq = 5 # sinusoidal!
export(int) var amp = 333
var time = 0.0

export(int) var max_hp = 1 # how many shots to kill
export(int) var damage = 5 # how much max damage they do to our shields

export(int) var min_speed = 200
export(int) var max_speed = 350

export(Color) var laser_color = Color("#ff0000")

var hp = max_hp

func _ready():
	randomize()
	$Explosion.set_visible(false) # hide explosion anim
	$Light2D.set_visible(false) # hide explosion light
	$Line2D.default_color = laser_color
	h_speed = rand_range(min_speed,max_speed) # set random speed (changes on dodgetimer)
	direction = directions[randi()%directions.size()] # set random direction
	position.y = spawn_y
	
	if direction == -1: # if facing left
		position.x = 320 # set it to the right edge
		scale = Vector2(-1, 1) # flip the graphics

func _process(delta):
	time += delta # for sine wave
	
	if dead:
		# fade out light and slow down speed if dead
		$Light2D.energy = lerp($Light2D.energy, 0, 0.02)
		h_speed = lerp(h_speed, 0, 0.05)
		v_speed = lerp(v_speed, 0, 0.5)
	else:
		# move in sine wave if not dead!
		v_speed = (cos(time*freq)*amp)*direction
		
	velocity.x = lerp(velocity.x, h_speed*direction, 0.3)
	velocity.y = lerp(velocity.y, v_speed, 0.3)
	velocity = move_and_slide(velocity)
	
	if !dead and position.x < -250 or position.x > 400:
		# if we're out of bounds of the "viewscreen"
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	# delete scene if leaves the screen
	queue_free()

func _on_Area2D_body_entered(_body):
	#when it gets hit by a phaser
	hp -= 1
	if hp <= 0:
		die()
	
func die():
	# when dead
	dead = true
	$CPUParticles2D.set_emitting(true) # show explosion bits
	$Sprite.queue_free() 
	$Area2D.queue_free() 
	$Line2D.set_visible(false)
	$Light2D.set_visible(true) # show explosion light
	$DodgeTimer.queue_free()
	
	$Explosion.rotation_degrees = rand_range(0,360) # random rotation for explosion juice!
	var explosion_size = rand_range(0.7, 1.3) # random scale for explosion
	$Explosion.scale = Vector2(explosion_size, explosion_size)
	$Explosion.set_visible(true)
	$Explosion.play("default")
	yield($Explosion, "animation_finished")
	queue_free()


func _on_ShootTimer_timeout():
	if dead:
		return false
		
	if randi()%2 and position.x > 0 and position.x < 320:
		$Line2D.add_point(target)
		print($Line2D.points.size())
		yield(get_tree().create_timer(0.1), "timeout")
		if $Line2D.points.size() >= 2:
			$Line2D.remove_point(1)
		$ShootTimer.wait_time = rand_range(1, 3)
		emit_signal("enemy_escaped", damage)


func _on_DodgeTimer_timeout():
	h_speed = rand_range(min_speed,max_speed)
