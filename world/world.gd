extends Node2D

var zombie = preload("res://zombie/zombie.tscn")
var person = preload("res://people/people.tscn")

@onready var zombie_timer = $ZombieTimer
@onready var person_timer = $PersonTimer
@onready var characterUI = $characterUI

func _ready():
	randomize()
	
	for i in range(0, 10):
		spawn_initial_zombie()
		spawn_initial_zombie()
		spawn_initial_person()

func spawn_zombie():
	var zombie_instance = zombie.instantiate()
	zombie_instance.global_position = generate_start()
	get_parent().call_deferred("add_child", zombie_instance)
		
	zombie_timer.start(randi_range(3, 5))

func spawn_person():
	var people_instance = person.instantiate()
	people_instance.global_position = generate_start()
	get_parent().call_deferred("add_child", people_instance)
	
	person_timer.start(randi_range(2, 4))

func spawn_initial_zombie():
	var zombie_instance = zombie.instantiate()
	zombie_instance.global_position = Vector2(randi_range(0, 640), randi_range(0, 480))
	get_parent().call_deferred("add_child", zombie_instance)

func spawn_initial_person():
	var people_instance = person.instantiate()
	people_instance.global_position = Vector2(randi_range(0, 640), randi_range(0, 480))
	get_parent().call_deferred("add_child", people_instance)

func _on_zombie_timer_timeout():
	spawn_zombie()

func _on_person_timer_timeout():
	spawn_person()

func generate_start():
	var pos = Vector2.ZERO
	var quad = randi_range(1, 4)
	
	match quad:
		1:
			pos.x = Global.ambulance.global_position.x + 170
			@warning_ignore("narrowing_conversion")
			pos.y = randi_range(Global.ambulance.global_position.y - 130, Global.ambulance.global_position.y + 130)
		2:
			pos.x = Global.ambulance.global_position.x - 170
			@warning_ignore("narrowing_conversion")
			pos.y = randi_range(Global.ambulance.global_position.y - 130, Global.ambulance.global_position.y + 130)
		3:
			pos.y = Global.ambulance.global_position.y - 130
			@warning_ignore("narrowing_conversion")
			pos.x = randi_range(Global.ambulance.global_position.x - 170, Global.ambulance.global_position.x + 170)
		4:
			pos.y = Global.ambulance.global_position.y + 130
			@warning_ignore("narrowing_conversion")
			pos.x = randi_range(Global.ambulance.global_position.x - 170, Global.ambulance.global_position.x + 170)
	
	return pos
