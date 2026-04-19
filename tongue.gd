extends Node3D

@export var target: Node3D
@onready var path_3d: Path3D = $Path3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target:
		path_3d.curve.set_point_position(
			1,
			target.global_position - global_position
		)
