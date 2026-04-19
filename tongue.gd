class_name Tongue
extends Node3D

signal target_reached(target: Node3D)
signal finished()

@export var time_to_reach := 0.3
@export var time_to_back := 0.2
@export var starting_node: Node3D
@export var target: Node3D

@onready var path_3d: Path3D = $Path3D
@onready var tongue_tip: CSGSphere3D = $TongueTip

func _ready() -> void:
	target_reached.connect(func(node): print_debug("Target reached ", node.name))
	finished.connect(func(): print_debug("Finished "))
	if target:
		start(starting_node if starting_node else self, target)

func start(from: Node3D, to: Node3D):
	starting_node = from
	target = to
	var tween = get_tree().create_tween()
	tween.tween_method(update_path, 0.0, 1.0, time_to_reach)
	tween.tween_callback(target_reached.emit.bind(to))
	tween.tween_method(update_path_2, 1.0, 0.0, time_to_back)
	tween.tween_callback(finished.emit)
	tween.tween_callback(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_path(progress: float) -> Vector3:
	if progress == 0.0:
		progress = 0.01
	var tip: Vector3 = lerp(starting_node.global_position, target.global_position, progress)
	var offset := tip - starting_node.global_position
	path_3d.curve.set_point_position(0, starting_node.global_position)
	path_3d.curve.set_point_out(0, (Vector3.UP+offset)/4)
	path_3d.curve.set_point_position(1, tip)
	path_3d.curve.set_point_in(0, -offset/4)
	tongue_tip.global_position = tip+0.2*Vector3.UP
	return tip
	
func update_path_2(progress: float) -> void:
	target.global_position = update_path(progress)
