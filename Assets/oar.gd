extends Node3D


@export var spins_per_second: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Convert spins/sec to radians/sec (1 spin = TAU radians)
	var radians_per_second = spins_per_second * TAU
	
	# Rotate around Y axis
	rotate_y(radians_per_second * delta)
