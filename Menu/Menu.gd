extends Window


@onready var DontPlay = $DontPlay
@onready var Background = $Background


var dontPlayTweenDir = -1


func _process(delta: float) -> void:
	Background.texture.noise.offset += Vector3(50 * delta, 50 * delta, 50 * delta)
	var mouse = get_mouse_position()
	if mouse.x < 340 and mouse.x > 170 and mouse.y > 300 and mouse.y < 360:
		if dontPlayTweenDir < 1:
			dontPlayTweenDir = 1
			create_tween().tween_property(DontPlay, "position", Vector2(182, 450), 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	if mouse.x < 340 and mouse.x > 170 and mouse.y > 445 and mouse.y < 505:
		if dontPlayTweenDir > -1:
			dontPlayTweenDir = -1
			create_tween().tween_property(DontPlay, "position", Vector2(182, 305), 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)


func _on_close_requested() -> void:
	hide()
	get_tree().quit()


func _on_settings_pressed() -> void:
	Master.addWindow("res://Menu/Settings/Settings.tscn", true, self)


func _on_play_pressed() -> void:
	Master.addWindow("res://Desktop/Desktop.tscn", true)
	queue_free()
