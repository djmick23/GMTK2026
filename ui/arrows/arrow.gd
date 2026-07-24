extends Sprite2D

var target

var life = 0

func _physics_process(delta: float) -> void:
	life += delta
	
	modulate.a = lerp(modulate.a, 0.0, 0.2 * delta)
	
	look_at(target)
	position = ((get_parent().global_position - target).normalized() * -50)
	
	if get_parent().global_position.distance_to(target) < 100 && life >= 1:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
