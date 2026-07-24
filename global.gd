extends Node

var arrow = preload("res://ui/arrows/arrow.tscn")
var menu = preload("res://ui/menu/menu.tscn")

var ambulance : CharacterBody2D

var ambulancePeople = 0
var score = 0
var time = 60

var pausable = false

func _physics_process(delta: float) -> void:
	time -= delta
	
	if time <= 0:
		game_over()

func add_arrow(person_pos):
	var arrow_instance = arrow.instantiate()
	arrow_instance.position = ((ambulance.global_position - person_pos).normalized() * -50)
	arrow_instance.target = person_pos
	ambulance.call_deferred("add_child", arrow_instance)

func game_over():
	get_tree().reload_current_scene()
	score = 0
	time = 60
	
	var menu_instance = menu.instantiate()
	call_deferred("add_child", menu_instance)
