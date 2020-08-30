extends KinematicBody2D

var directions = [-1, 1]
var h_speed = 0
var v_speed = 0
var direction = 1
var velocity = Vector2()
var spawn_y = rand_range(15,200)
var dead = false
signal enemy_escaped
var target = Vector2()

# TODO setup hp usage
var max_hp = 1
var hp = 1
var max_speed = 1000

func _ready():
	randomize()
	$Explosion.set_visible(false)
	$Light2D.set_visible(false)
	h_speed = rand_range(100,max_speed)
	v_speed = rand_range(-50, 50)
	direction = directions[randi()%directions.size()]
	position.y = spawn_y
	if direction == -1:
		position.x = 320
		scale = Vector2(-1, 1)

func _process(delta):
	if dead:
		$Light2D.energy = lerp($Light2D.energy, 0, 0.02)
		h_speed = lerp(h_speed, 0, 0.05)
		v_speed = lerp(v_speed, 0, 0.05)
	velocity.x = lerp(velocity.x, h_speed * direction, 0.3)
	velocity.y = lerp(velocity.y, v_speed * direction, 0.3)
	velocity = move_and_slide(velocity)
	if !dead and position.x < -250 or position.x > 400:
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Area2D_body_entered(body):
	#when it gets hit by a phaser
	die()
	
func die():
	dead = true
	$CPUParticles2D.set_emitting(true)
	$Sprite.queue_free()
	$Area2D.queue_free()
	$Line2D.set_visible(false)
	$Light2D.set_visible(true)
	$DodgeTimer.queue_free()
	$Explosion.rotation_degrees = rand_range(0,360)
	var explosion_size = rand_range(0.7, 1.3)
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
		emit_signal("enemy_escaped")


func _on_DodgeTimer_timeout():
	h_speed = rand_range(100,max_speed)
	v_speed = rand_range(-100,100)
