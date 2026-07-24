extends CharacterBody2D

@onready var _sprites = $sprites
@onready var bufferTimer = $BufferTimer
@onready var particlesL = $"sprites/1/TireL/Particles"
@onready var particlesR = $"sprites/1/TireR/Particles"


var speed = 125
var acceleration = 180
var friction = 140
var air_resistance = 30
var turn_speed = 5

var z = 0
var z_speed = 0
var gravity = 400
var jump = 125

var buffer = false
var landed = true

func _ready() -> void:
	Global.ambulance = self

func _physics_process(delta: float) -> void:
	#Movement
	var direction : Vector2 = global_position.direction_to(get_global_mouse_position())
	
	if z >= 0:
		if Input.is_action_pressed("click"):
			velocity = velocity.move_toward(direction * speed, acceleration * delta)
			SfxLibrary.play("Drive")
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, air_resistance * delta)
		
	move_and_slide()

	#Jump
	if Input.is_action_just_pressed("jump"):
		if z == 0:
			z_speed = -jump
			landed = false
		else:
			buffer = true
			bufferTimer.start()
	
	if Input.is_action_just_released("jump") && z_speed < 0:
		z_speed *= 0.75
	
	z_speed += gravity * delta
	z += z_speed * delta
	
	if z >= 0:
		z = 0
		
		if !landed:
			landed = true
			SfxLibrary.play("Land")
		
		if buffer:
			z_speed = -jump
			SfxLibrary.play("Land")
			landed = false
	
	#Rotation
	var mouse_pos = get_global_mouse_position()
	
	if Input.is_action_pressed("click"):
		var target_angle = global_position.angle_to_point(mouse_pos)
		
		for sprite in _sprites.get_children():
			sprite.rotation = lerp_angle(sprite.rotation, target_angle, turn_speed * delta)
	
	for sprite in _sprites.get_children():
		if sprite.name != "0":
			sprite.position = Vector2(0, (11 - int(sprite.name)) + z)
	
	#Particles
	particlesL.emitting = false
	particlesR.emitting = false
	
	if z >= 0 && velocity.length() > 20:
		if velocity.x > 30 && mouse_pos.x < global_position.x:
			particlesL.emitting = true
			particlesR.emitting = true
			
			if Input.is_action_pressed("click"):
				SfxLibrary.play("Drift1")
		if velocity.x < -30 && mouse_pos.x > global_position.x:
			particlesL.emitting = true
			particlesR.emitting = true
			
			if Input.is_action_pressed("click"):
				SfxLibrary.play("Drift1")
		if velocity.y > 30 && mouse_pos.y < global_position.y:
			particlesL.emitting = true
			particlesR.emitting = true
			
			if Input.is_action_pressed("click"):
				SfxLibrary.play("Drift1")
		if velocity.y < -30 && mouse_pos.y > global_position.y:
			particlesL.emitting = true
			particlesR.emitting = true
			
			if Input.is_action_pressed("click"):
				SfxLibrary.play("Drift1")

func _on_buffer_timer_timeout() -> void:
	buffer = false
