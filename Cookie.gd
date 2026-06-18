extends Window


func _ready() -> void:
	$AudioStreamPlayer.play()


func _process(delta: float) -> void:
	for child in get_children():
		if not child is Sprite2D:
			break
		child.scale *= randf_range(1 + (1.6 * delta), 1 + (2.6 * delta))
		if child.scale.x >= 6:
			child.queue_free()
	if get_child_count() == 1:
		queue_free()
