extends ColorRect


func _ready() -> void:
	show()
	if get_child_count() > 0:
		queueSound()
	await create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 6).finished
	queue_free()


func queueSound():
	await get_tree().create_timer(1).timeout
	$StartupPlayer.play()
