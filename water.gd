@tool
class_name WaterSurface
extends Node3D

# kgs/m3
@export var water_density: float = 1000.0

var time_elapsed: float = 0.0

@onready var water_surface: MeshInstance3D = $WaterSurface
@onready var material: ShaderMaterial = water_surface.get_surface_override_material(0)
@onready var wave_a: NoiseTexture2D = material.get_shader_parameter("wave_a")
@onready var wave_a_image: Image = wave_a.noise.get_seamless_image(512, 512)
@onready var wave_a_direction: Vector2 = material.get_shader_parameter("wave_move_direction_a")
@onready var wave_a_noise_scale: float = material.get_shader_parameter("wave_noise_scale_a")
@onready var wave_a_time_scale: float = material.get_shader_parameter("wave_time_scale_a")
@onready var wave_b: NoiseTexture2D = material.get_shader_parameter("wave_b")
@onready var wave_b_image: Image = wave_b.noise.get_seamless_image(512, 512)
@onready var wave_b_direction: Vector2 = material.get_shader_parameter("wave_move_direction_b")
@onready var wave_b_noise_scale: float = material.get_shader_parameter("wave_noise_scale_b")
@onready var wave_b_time_scale: float = material.get_shader_parameter("wave_time_scale_b")
@onready var wave_height_scale: float = material.get_shader_parameter("wave_height_scale")

func _process(delta: float) -> void:
	time_elapsed += delta
	material.set_shader_parameter("wave_time", time_elapsed)

func get_water_height(gpos: Vector3) -> float:
	# Convert global position to local UV coordinates
	var local_pos: Vector3 = global_transform.affine_inverse() * gpos
	var vertex_uv: Vector2 = Vector2(local_pos.x, local_pos.z)
	
	# Calculate UVs for both noise textures
	var uv_a: Vector2 = vertex_uv / wave_a_noise_scale + (wave_a_direction * time_elapsed * wave_a_time_scale)
	var uv_b: Vector2 = vertex_uv / wave_b_noise_scale + (wave_b_direction * time_elapsed * wave_b_time_scale)
	var px_a: int = floor(wrapf(uv_a.x, 0.0, 1.0) * wave_a_image.get_width())
	var py_a: int = floor(wrapf(uv_a.y, 0.0, 1.0) * wave_a_image.get_height())
	var px_b: int = floor(wrapf(uv_b.x, 0.0, 1.0) * wave_b_image.get_width())
	var py_b: int = floor(wrapf(uv_b.y, 0.0, 1.0) * wave_b_image.get_height())

	# Sample noise textures and average the Y-values
	var height1: float = wave_a_image.get_pixel(px_a, py_a).v
	var height2: float = wave_b_image.get_pixel(px_b, py_b).v
	var avg_height: float = (height1 + height2) * 0.5

	# Apply height scale
	return avg_height * wave_height_scale
