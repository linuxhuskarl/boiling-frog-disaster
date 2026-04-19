extends Label3D

var tween: Tween

func _ready():
	visible = false

func show_subtitle(text: String):
	self.text = text
	visible = true
	
	if tween:
		tween.kill()
	
	modulate.a = 0.0
	
	tween = create_tween()
	
	# fade in
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	
	# pauza
	tween.tween_interval(2.0)
	
	# fade out
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	
	tween.tween_callback(func(): visible = false)
