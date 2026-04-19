class_name InteractibleComponent
extends Node3D

@export var mesh: MeshInstance3D
const ZAZNACZA_MATERIAL = preload("uid://bfdxg6fard5js")

var highlighted := false:
	get:
		return highlighted
	set(value):
		if value and not highlighted:
			mesh.material_overlay = ZAZNACZA_MATERIAL
		elif not value and highlighted:
			mesh.material_overlay = null
		highlighted = value
