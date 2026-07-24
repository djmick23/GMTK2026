extends Line2D

var point

func _ready() -> void:
	set_as_top_level(true)

func _physics_process(_delta: float) -> void:
	if get_parent().get_parent().get_parent().get_parent().z >= 0:
		point = get_parent().global_position
		add_point(point)
		
		if points.size() > 25:
			remove_point(0)
	else:
		if points.size() > 0:
			remove_point(0)
