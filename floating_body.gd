class_name FloatingBody3D
extends RigidBody3D

@export var probe_container: Node3D
@export_group("Size")
@export var max_depth: float = 0.5
@export var frontal_area: float = 1.0
@export var side_area: float = 1.0
@export var bottom_area: float = 1.0
@export_group("Physical Properties")
@export var angular_drag_coeff: float = 0.05
@export var shape_drag_coeff: float = 0.05
@export var friction_drag_coeff: float = 0.001

var volume: float = bottom_area * max_depth
var submerged: bool = false
var probes: Array[Marker3D]
var volume_per_probe: float = volume
var submerged_average_position: Vector3

@onready var gravity: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity") \
	* ProjectSettings.get_setting("physics/3d/default_gravity_vector")
@onready var water: WaterSurface = get_tree().get_first_node_in_group("water") as WaterSurface

func _ready() -> void:
	if probe_container:
		var children := probe_container.get_children()
		for child in children:
			var probe := child as Marker3D
			if probe:
				probes.append(probe)
		volume_per_probe = volume / len(probes)
	print_debug("Probe count: ", len(probes))

func square_sign(v: float):
	return v * abs(v)

func apply_linear_drag(submersion_ratio: float):
	var density: float = 1.225 # base air density in kg/m3
	if submerged:
		density = water.water_density
	else:
		#ignore the submersion ratio if not in water
		submersion_ratio = 1.0
	
	var forward := global_basis.z
	var sideways := global_basis.x
	var upward := global_basis.y
	var forward_speed := linear_velocity.dot(forward)
	var sideways_speed := linear_velocity.dot(sideways)
	var upward_speed := linear_velocity.dot(upward)
	
	# shape drag
	apply_force(
		-forward * square_sign(forward_speed) * density * shape_drag_coeff * frontal_area * submersion_ratio\
		-sideways * square_sign(sideways_speed) * density * shape_drag_coeff * side_area * submersion_ratio\
		-upward * square_sign(upward_speed) * density * shape_drag_coeff * bottom_area
	)
	# friction drag
	var area = bottom_area + 2 * (frontal_area + side_area) * submersion_ratio
	apply_force(
		-linear_velocity * linear_velocity.length() * density * area * friction_drag_coeff
	)

func _physics_process(_delta: float) -> void:
	submerged = false
	var subm_list: Array[Dictionary]
	var total_displacement := 0.0
	for probe in probes:
		var water_level: float = water.get_water_height(probe.global_position)
		var depth := water_level - probe.global_position.y
		if depth > 0:
			submerged = true
			var displacement = volume_per_probe * clampf(depth / max_depth, 0.0, 1.0)
			total_displacement += displacement
			apply_force(-gravity * displacement * water.water_density, probe.global_position - global_position)
			subm_list.append({
				gpos = probe.global_position,
				disp = displacement
			})
	submerged_average_position = Vector3.ZERO
	for stat in subm_list:
		submerged_average_position += stat["gpos"] * stat["disp"] / total_displacement
	apply_linear_drag(total_displacement / volume)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if submerged:
		state.angular_velocity *= (1 - angular_drag_coeff)
