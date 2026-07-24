extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var move_timer = $MoveTimer
@onready var collider = $Area2D/CollisionShape2D
@onready var collider2 = $CollisionShape2D
@onready var _area = $Area2D
@onready var chase = $chase

var movedir = Vector2.ZERO

var speed = 1000
var friction = 6

var entered_screen = false

func _ready():
	randomize()
	
	#initial direction
	movedir.x = (randf() * 2) - 1
	movedir.y = (randf() * 2) - 1
	movedir = movedir.normalized()
	
	#randomize speed
	speed = randi_range(500, 1000)

func _physics_process(delta):
	if anim.current_animation != "die":
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
			anim.play("idle")
		else:
			anim.play("run")
		
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
	
	for body in _area.get_overlapping_bodies():
		if body.is_in_group("ambulance"):
			if body.z >= 0:
				if anim.current_animation != "die":
					die()
		
		if body.is_in_group("people"):
			body.queue_free()

func _on_move_timer_timeout():
	movedir.x = (randf() * 2) - 1
	movedir.y = (randf() * 2) - 1
	movedir = movedir.normalized()
	
	move_timer.start(randf() * 5)

func die():
	SfxLibrary.play("Splat1")
	SfxLibrary.play("Splat2")
	collider.call_deferred("set_disabled", true)
	Global.score += 1
	anim.play("die")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("people"):
		area.get_parent().die("zombie")

func _on_chase_area_entered(area: Area2D) -> void:
	if area.is_in_group("people"):
		movedir = (area.global_position - global_position).normalized()
