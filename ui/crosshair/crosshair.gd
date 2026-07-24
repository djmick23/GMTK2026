extends Sprite2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		
		visible = !visible

func _physics_process(_delta):
	global_position = get_global_mouse_position()
	
	if Input.is_action_pressed("click"):
		frame = 1
	else:
		frame = 0
