class_name BabaYaga
extends Node3D

signal game_over
signal baba_hurt

var max_hp := 3
var current_hp := max_hp

@onready var interactible_component: InteractibleComponent = %InteractibleComponent

func hurt():
	current_hp = current_hp - 1
	if current_hp <= 0:
		# umieraaa sound
		game_over.emit()
	else:
		# play baba AAAH sound
		baba_hurt.emit()
