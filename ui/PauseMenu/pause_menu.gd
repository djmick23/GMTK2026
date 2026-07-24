extends CanvasLayer

func _ready():
	get_tree().paused = false
	
	for child in get_children():
		child.visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel") && Global.pausable:
		get_tree().paused = !get_tree().paused
		
		for child in get_children():
			child.visible = !child.visible
