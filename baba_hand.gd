extends Node3D

@onready var baba_hand: MeshInstance3D = $BabaHand
@onready var animation_player: AnimationPlayer = $AnimationPlayer
signal hand_animation

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		play_hand()

func play_hand():
	hand_animation.emit()
	animation_player.play("throwing")
