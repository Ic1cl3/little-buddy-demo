extends ColorRect


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		show()
	else:
		hide()
