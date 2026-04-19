class_name GameManager
extends Node3D

@onready var baba_yaga: BabaYaga = $"../BabaYaga"
@onready var camera: PhantomCamera3D = $"../PhantomCamera3D"
@onready var music_player: AudioStreamPlayer3D = $"../Camera3D/AudioStreamPlayer3D"
@onready var hand_timer: Timer = $HandTimer
@onready var baba_hand: BabaHand = $"../BabaHand"
@onready var path_follow_3d: PathFollow3D = $"../Path3D/PathFollow3D"

@onready var wybuchy: AudioStreamPlayer3D = $"../BabaYaga/Wybuchy"


const APPLE = preload("uid://c5eegtngr4qwg")
const ONION = preload("uid://dni4cep1qutqy")
const POTATO = preload("uid://nnwfiom6iyr3")
const EYEBALL = preload("uid://dduervr7vihuf")

var lista_hp3 := [
	APPLE, APPLE,
	ONION, ONION,
	POTATO, POTATO
]

var lista_hp2 := [
	APPLE, APPLE,
	ONION, ONION,
	POTATO, POTATO,
	EYEBALL, EYEBALL
]

var lista_hp1 := [
	APPLE,
	ONION,
	POTATO,
	EYEBALL, EYEBALL, EYEBALL, EYEBALL
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_timer.start()
	baba_yaga.baba_hurt.connect(func():
		var tween := get_tree().create_tween()
		tween.tween_property(camera.noise, "amplitude", 20, 0.1)
		tween.tween_property(camera.noise, "amplitude", 0, 0.4)
		wybuchy.play()
		if baba_yaga.current_hp == 2:
			music_player["parameters/switch_to_clip"] = &"Calm Transition To Action"
		if baba_yaga.current_hp == 1:
			music_player["parameters/switch_to_clip"] = &"Action 2"
		if baba_yaga.current_hp == 0:
			music_player["parameters/switch_to_clip"] = &"Calm"
	)

func _on_hand_timer_timeout() -> void:
	# check if there is not that much items and generate new
	if baba_yaga.current_hp == 0:
		return
	var interactibles := get_tree().get_nodes_in_group("interactibles")
	var food_count := 0
	for item in interactibles:
		var food := item as FoodItem
		if food and food.food_type != FoodItem.FoodType.EYE and food.food_type != FoodItem.FoodType.BOMB:
			food_count += 1
	if food_count <= 4:
		baba_hand.play_hand()
		var lista := lista_hp3
		if baba_yaga.current_hp == 2:
			lista = lista_hp2
		if baba_yaga.current_hp == 1:
			lista = lista_hp1
		for scene: PackedScene in lista:
			path_follow_3d.progress_ratio = randf()
			var food = scene.instantiate() as Node3D
			add_sibling(food)
			food.global_position = path_follow_3d.global_position
