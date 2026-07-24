extends CanvasLayer

@onready var label = $Label
@onready var label2 = $Label2

func _process(_delta):
	label.text = "SCORE: " + str(Global.score)
	label2.text = "TIME: " + str(int(Global.time))
