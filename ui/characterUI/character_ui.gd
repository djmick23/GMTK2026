extends CanvasLayer

@onready var people = $characterUI

func _physics_process(_delta: float) -> void:
	people.frame = Global.ambulancePeople
