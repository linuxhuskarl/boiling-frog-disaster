class_name BabaYaga
extends Node3D

signal game_over
signal baba_hurt

var max_hp := 3
var current_hp := max_hp
var baba_tween: Tween

@onready var interactible_component: InteractibleComponent = %InteractibleComponent
@onready var mesh: MeshInstance3D = $BabaYaga

func hurt():
	current_hp = current_hp - 1
	if current_hp <= 0:
		# umieraaa sound
		game_over.emit()
	else:
		# play baba AAAH sound
		baba_tween = get_tree().create_tween()
		var material := mesh.get_surface_override_material(0) as StandardMaterial3D
		baba_tween.tween_property(material, "albedo_color", Color.RED, 0.1)
		baba_tween.tween_property(material, "albedo_color", Color.WHITE, 0.4)
		baba_hurt.emit()
