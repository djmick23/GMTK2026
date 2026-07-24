extends CharacterBody2D

var zombie = preload("res://zombie/zombie.tscn")

@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var move_timer = $MoveTimer
@onready var collider = $Area2D/CollisionShape2D
@onready var area = $Area2D

var movedir = Vector2.ZERO

var speed = 1000
var friction = 6
var person = 0

var entered_screen = false

func _ready():
	randomize()
	
	person = randi_range(0, 1)
	sprite.frame = person * 3
	
	#initial direction
	movedir.x = (randf() * 2) - 1
	movedir.y = (randf() * 2) - 1
	movedir = movedir.normalized()
	
	#randomize speed
	speed = randi_range(400, 600)

func _physics_process(delta):
	if anim.current_animation != ("die" + str(person)) && anim.current_animation != ("die2" + str(person)):
		#movement
		velocity = movedir * speed * delta
		move_and_slide()
		
		#spritedir
		if movedir.x > 0:
			sprite.flip_h = false
		elif movedir.x < 0:
			sprite.flip_h = true
		
		#animation
		if movedir == Vector2.ZERO:
			anim.play("idle" + str(person))
		else:
			anim.play("run" + str(person))
		
		#boundaries
		if entered_screen:
			if global_position.x > 640:
				movedir.x *= -1
				global_position.x = 640
			if global_position.x < 0:
				movedir.x *= -1
				global_position.x = 0
			if global_position.y > 480:
				movedir.y *= -1
				global_position.y = 480
			if global_position.y < 5:
				movedir.y *= -1
				global_position.y = 5
		else:
			if global_position.x < 640 && global_position.x > 0 && global_position.y < 480 && global_position.y > 5 && !entered_screen:
				entered_screen = true
				move_timer.start(randf() * 5)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction * delta)
		move_and_slide() 
	
	for body in area.get_overlapping_bodies():
		if body.is_in_group("ambulance"):
			if body.z >= 0:
				if anim.current_animation != ("die" + str(person)):
					die2()
					Global.score -= 1
				elif Global.ambulancePeople < 3:
					Global.ambulancePeople += 1
					SfxLibrary.play("Score")
					queue_free()

func _on_move_timer_timeout():
	movedir.x = (randf() * 2) - 1
	movedir.y = (randf() * 2) - 1
	movedir = movedir.normalized()
	
	move_timer.start(randf() * 5)

func die(source):
	if source == "ambulance":
		SfxLibrary.play("Splat1")
		SfxLibrary.play("Splat2")
	elif source == "zombie":
		SfxLibrary.play("Hurt")
	
	anim.play("die" + str(person))
	
	Global.add_arrow(global_position)

func die2():
	SfxLibrary.play("Splat1")
	SfxLibrary.play("Splat2")
	collider.call_deferred("set_disabled", true)
	anim.play("die2" + str(person))

func change():
	SfxLibrary.play("Zombie")
	var zombie_instance = zombie.instantiate()
	zombie_instance.global_position = global_position
	get_parent().call_deferred("add_child", zombie_instance)
	queue_free()
