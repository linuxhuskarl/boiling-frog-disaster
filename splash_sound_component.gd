extends AudioStreamPlayer3D

@export var floating_body: FloatingBody3D

func _ready():
	floating_body.entered_water.connect(func():
		play()
	)
	floating_body.exited_water.connect(func():
		pass
	)
