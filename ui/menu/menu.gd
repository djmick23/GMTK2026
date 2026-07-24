extends CanvasLayer

@onready var anim = $AnimationPlayer

func _ready():
	get_tree().paused = true
	Global.pausable = false

func _process(_delta):
	if anim.current_animation != "start":
		anim.play("bounce")

func _on_button_pressed():
	anim.play("start")
	Global.pausable = true
	
	SfxLibrary.play("SwitchMenu")

func start():
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free()
