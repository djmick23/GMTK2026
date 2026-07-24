extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("ambulance"):
		if Global.ambulancePeople > 0:
			SfxLibrary.play("Score2")
		
		Global.time += Global.ambulancePeople * 5
		Global.ambulancePeople = 0
