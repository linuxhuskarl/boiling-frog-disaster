extends FloatingBody3D

@export var forward_rowing_force := 100.0
@export var rotation_rowing_force := 100.0
@export var strokes_per_minute := 30.0

var seconds_per_stoke := 60.0 / strokes_per_minute
# 0.0 to 1.0
var rowing_phase: float = 0.0
var state: RowState = RowState.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var forward_input := Input.get_axis("row_forward", "row_backward")
	var rotation_input := Input.get_axis("row_clockwise", "row_anticlockwise")
	
	match state:
		RowState.IDLE:
			rowing_phase = 0.0
			if forward_input:
				print_debug("Changing state FORWARD")
				state = RowState.FORWARD
			elif rotation_input:
				print_debug("Changing state CLOCKWISE")
				state = RowState.CLOCKWISE
		RowState.RETURNING:
			rowing_phase += delta / seconds_per_stoke
			if rowing_phase >= 1.0:
				print_debug("Changing state IDLE")
				state = RowState.IDLE
		RowState.FORWARD:
			rowing_phase += delta / seconds_per_stoke
			if forward_input and rowing_phase < 0.5:
				var forward = global_basis.z.slide(gravity.normalized())
				apply_force(forward * forward_input * forward_rowing_force)
			elif rotation_input and rowing_phase < 0.5:
				var up = global_basis.y
				apply_torque(up * rotation_input * rotation_rowing_force)
			else:
				print_debug("Changing state RETURNING")
				rowing_phase = 1.0 - rowing_phase
				state = RowState.RETURNING
		RowState.CLOCKWISE:
			rowing_phase += delta / seconds_per_stoke
			if rotation_input and rowing_phase < 0.5:
				var up = global_basis.y
				apply_torque(up * rotation_input * rotation_rowing_force)
			else:
				print_debug("Changing state RETURNING")
				rowing_phase = 1.0 - rowing_phase
				state = RowState.RETURNING

enum RowState {
	IDLE,
	RETURNING,
	FORWARD,
	CLOCKWISE,
}
