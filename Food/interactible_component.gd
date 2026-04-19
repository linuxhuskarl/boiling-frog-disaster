class_name InteractibleComponent
extends Node3D

@export var mesh: MeshInstance3D
@export var baba_yaga := false

var baba_tween: Tween

const ZAZNACZA_MATERIAL = preload("uid://bfdxg6fard5js")

var highlighted := false:
	get:
		return highlighted
	set(value):
		if baba_yaga:
			print_debug("BABA LAGA", value)
			if value and not highlighted:
				print_debug("BABA LAGA starting")
				#start tween
				baba_tween = get_tree().create_tween()
				baba_tween.set_loops()
				var material := mesh.get_surface_override_material(0) as StandardMaterial3D
				baba_tween.tween_property(material, "albedo_color", Color.GRAY, 0.2)
				baba_tween.tween_property(material, "albedo_color", Color.WHITE, 0.2)
			elif not value and highlighted:
				print_debug("BABA LAGA stop")
				baba_tween.stop()
				baba_tween = null
		else:
			if value and not highlighted:
				mesh.material_overlay = ZAZNACZA_MATERIAL
			elif not value and highlighted:
				mesh.material_overlay = null
		highlighted = value
