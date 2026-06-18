extends Window


@onready var Background = $Background
@onready var label = $Label
@onready var slide1 = $HSlider1
@onready var slide2 = $HSlider2
@onready var slide3 = $HSlider3
@onready var slide4 = $HSlider4
@onready var slide5 = $HSlider5


func _process(delta: float) -> void:
	Background.texture.noise.offset += Vector3(50 * delta, 50 * delta, 50 * delta)
	label.text = "Volumetric graphic mipmap"
	for slider in [slide1, slide2, slide3, slide4, slide5]:
		if slider.value < 100:
			label.text = "Who said you get to make\nthe rules?"
			slider.value += 100 * delta


func _on_close_requested() -> void:
	queue_free()
