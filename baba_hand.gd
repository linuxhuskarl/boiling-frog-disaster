extends Node3D

@onready var baba_hand: MeshInstance3D = $BabaHand
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		play_hand()

func play_hand():
	animation_player.play("throwing")
