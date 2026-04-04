extends FloatingBody3D

@export var forward_rowing_force := 100.0
@export var rotation_rowing_force := 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var forward_input := Input.get_axis("row_forward", "row_backward")
	var rotation_input := Input.get_axis("row_clockwise", "row_anticlockwise")
	
	if forward_input:
		var forward = global_basis.z.slide(gravity.normalized())
		apply_force(forward * forward_input * forward_rowing_force)
	if rotation_input:
		var up = global_basis.y
		apply_torque(up * rotation_input * rotation_rowing_force)
