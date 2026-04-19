class_name Frog
extends Node3D

signal animation_finished(anim_name: StringName)

@export var default_head_target: Node3D
@export var head_target: Node3D:
	get:
		return head_target
	set(value):
		head_target = value
		_update_head_target()

@onready var head_ik: LookAtModifier3D = $"frogga-nm2-rigged/Armature/Skeleton3D/HeadIK"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _update_head_target():
	if head_target:
		head_ik.target_node = head_target.get_path()
	elif default_head_target: 
		head_ik.target_node = default_head_target.get_path()
	else:
		head_ik.target_node = ^""
	print_debug("Updating target ", head_ik.target_node)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_head_target()

func play_animation(anim_name: StringName, speed: float = 1.0):
	animation_player.play(anim_name, -1, speed)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_finished.emit(anim_name)
