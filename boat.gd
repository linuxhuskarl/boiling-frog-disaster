extends FloatingBody3D

@export var forward_rowing_force := 1500.0
@export var rotation_rowing_force := 2000.0
@export var strokes_per_minute := 60.0

var seconds_per_stoke := 60.0 / strokes_per_minute
# 0.0 to 1.0
var rowing_phase: float = 0.0
var state: RowState = RowState.IDLE
var current_target: Node3D = null

@onready var frog: Frog = $Frog
@onready var seeker: TargetSeekerComponent = $Frog/SelectATargetComponent

func try_change_highlight(target: Node3D, value: bool):
	if not target: return
	var ic := target.find_child("InteractibleComponent") as InteractibleComponent
	if ic: ic.highlighted = value

func _ready() -> void:
	super._ready()
	seeker.target_found.connect(func(target: Node3D):
		if current_target != target:
			print_debug("Updated target: ", target)
			try_change_highlight(current_target, false)
			current_target = target
			try_change_highlight(current_target, true)
			frog.head_target = current_target
	)
	seeker.no_target_found.connect(func():
		if current_target:
			print_debug("Lost target: ", current_target)
			try_change_highlight(current_target, false)
		current_target = null
		frog.head_target = null
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var forward_input := Input.get_action_strength("row_forward")
	var rotation_input := Input.get_axis("row_anticlockwise", "row_clockwise")
	
	if Input.is_action_just_pressed("row_backward"):
		seeker.seek_active = true
	elif Input.is_action_just_released("row_backward"):
		seeker.seek_active = false
	
	match state:
		RowState.IDLE:
			rowing_phase = 0.0
			if rotation_input:
				print_debug("Changing state CLOCKWISE")
				state = RowState.CLOCKWISE
				if rotation_input < 0:
					frog.play_animation("clockwise")
				else:
					frog.play_animation("anticlockwise")
			elif forward_input:
				print_debug("Changing state FORWARD")
				state = RowState.FORWARD
				frog.play_animation("forward")
			else:
				frog.play_animation("idle")
		RowState.RETURNING:
			rowing_phase += delta / seconds_per_stoke
			if rowing_phase >= 1.0:
				print_debug("Changing state IDLE")
				state = RowState.IDLE
		RowState.FORWARD:
			rowing_phase += delta / seconds_per_stoke
			if forward_input and rowing_phase < 0.5:
				var forward = -global_basis.z
				apply_central_force(forward * forward_input * forward_rowing_force)
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
