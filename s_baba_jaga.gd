extends AudioStreamPlayer3D

@onready var timer = $Timer
@onready var subtitle = $"../Didaskalia" 

var damage_voice_playing := false

var sounds = [
	{ "stream": preload("res://sounds/BabaJaga/Aaaaahhhh.ogg"), "text": "Baba Yaga: Aaaaahhhh" },
	{ "stream": preload("res://sounds/BabaJaga/ChodzDoMamy.ogg"), "text": "Baba Yaga: Come to mommy" },
	{ "stream": preload("res://sounds/BabaJaga/DajMiBuzi.ogg"), "text": "Baba Yaga: Give me a kiss" },
	{ "stream": preload("res://sounds/BabaJaga/Hahahaha.ogg"), "text": "Baba Yaga: Hahahaha!" },
	{ "stream": preload("res://sounds/BabaJaga/NoChodzDoMamy.ogg"), "text": "Baba Yaga: Oh, come to mommy" },
	{ "stream": preload("res://sounds/BabaJaga/NoChooodz.ogg"), "text": "Baba Yaga: Oh, come on!" },
	{ "stream": preload("res://sounds/BabaJaga/PokazDupe.ogg"), "text": "Baba Yaga: That's all you have?" },
	{ "stream": preload("res://sounds/BabaJaga/WezmeTylkoGryza.ogg"), "text": "Baba Yaga: It will be just a bite" }
]

var first_play := true
var last_index := -1


func _ready():
	randomize()
	_set_next_time()


func _on_timer_timeout():
	if not playing and not damage_voice_playing:

		var i = randi() % sounds.size()

		# NIE pozwól na powtórkę pod rząd
		while i == last_index:
			i = randi() % sounds.size()

		last_index = i
		var s = sounds[i]

		stream = s["stream"]
		pitch_scale = randf_range(0.9, 1.1)
		play()

		subtitle.show_subtitle(s["text"])

	_set_next_time()


func _set_next_time():
	if first_play:
		timer.wait_time = randf_range(5.0, 10.0)
		first_play = false
	else:
		timer.wait_time = randf_range(8.0, 14.0)

	timer.start()


func _on_wybuchy_damage_voice_finished() -> void:
	damage_voice_playing = false


func _on_wybuchy_damage_voice_started() -> void:
	damage_voice_playing = true
