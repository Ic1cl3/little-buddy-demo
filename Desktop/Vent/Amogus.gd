extends Window


func _ready() -> void:
	$AudioStreamPlayer.play()
	await create_tween().tween_property($Amog, "scale", Vector2(1, 0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).finished
	queue_free()
