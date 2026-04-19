class_name GameManager
extends Node3D

@onready var baba_yaga: BabaYaga = $"../BabaYaga"
@onready var camera: PhantomCamera3D = $"../PhantomCamera3D"
@onready var music_player: AudioStreamPlayer3D = $"../Camera3D/AudioStreamPlayer3D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	baba_yaga.baba_hurt.connect(func():
		var tween := get_tree().create_tween()
		tween.tween_property(camera.noise, "amplitude", 20, 0.1)
		tween.tween_property(camera.noise, "amplitude", 0, 0.4)
		
		if baba_yaga.current_hp == 2:
			music_player["parameters/switch_to_clip"] = &"Calm Transition To Action"
		if baba_yaga.current_hp == 1:
			music_player["parameters/switch_to_clip"] = &"Action 2"
		if baba_yaga.current_hp == 0:
			music_player["parameters/switch_to_clip"] = &"Calm"
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
