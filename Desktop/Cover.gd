extends ColorRect


func _ready() -> void:
	show()
	queueSound()
	await create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 6).finished
	queue_free()


func queueSound():
	await get_tree().create_timer(1).timeout
	$StartupPlayer.play()
