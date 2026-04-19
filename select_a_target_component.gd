class_name TargetSeekerComponent
extends Node3D

signal no_target_found()
signal target_found(target: Node3D)

@export var frog: Frog
@export var detection_range := 10.0

var seek_active: bool = true:
	get:
		return seek_active
	set(value):
		seek_active = value
		if seek_active:
			_process_seeking()
			timer.start()
			timer.paused = false
		else:
			timer.stop()
			timer.paused = true
			highlighted = null
			no_target_found.emit()

var highlighted: Node3D

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_process_seeking)

func _process_seeking():
	var available_list := get_tree().get_nodes_in_group("interactibles")
	var closest_one: Node3D = null
	var closest_length2 := detection_range * detection_range
	for item: Node3D in available_list:
		var distance := item.global_position.distance_squared_to(global_position)
		if distance < closest_length2:
			closest_one = item
			closest_length2 = distance
	highlighted = closest_one
	if highlighted:
		target_found.emit(highlighted)
	else:
		no_target_found.emit()
