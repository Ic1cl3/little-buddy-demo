extends Window



var shatFrame = -1
var game = false
var butDir = Vector2(randf(), randf()).normalized()
var musicTimer = 120
@onready var shatter = $Shatter
@onready var flash = $Flash
@onready var bang = $Bang
@onready var button = $Button
@onready var music = $Music
@onready var music2 = $Music2


func _ready() -> void:
	button.hide()
	await get_tree().create_timer(7).timeout
	for i in range(6):
		hit()
		await get_tree().create_timer(3).timeout


func _process(delta: float) -> void:
	musicTimer += delta
	shatter.play(str(shatFrame))
	@warning_ignore("integer_division")
	shatter.offset = Vector2(size/2) + Vector2(36, -39)
	if game:
		button.show()
		butDir += (Vector2(randf(), randf()).normalized())*2
		butDir = butDir.normalized()
		button.position += (butDir) * delta * 1700
		if button.position.y < -192:
			button.position.y = size.y
		if button.position.y > size.y:
			button.position.y = -192
		if button.position.x < -192:
			button.position.x = size.x
		if button.position.x > size.x:
			button.position.x = -192
		if musicTimer > 81.65:
			if music.playing:
				music2.play()
			else:
				music.play()
			musicTimer = 0


func hit():
	bang.play()
	flash.color = Color.WHITE
	flash.show()
	create_tween().tween_property(flash, "color", Color.TRANSPARENT, 1.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	shatFrame += 1


func _on_button_pressed() -> void:
	hide()
	Master.addWindow("res://End/End.tscn", true)
	queue_free()
