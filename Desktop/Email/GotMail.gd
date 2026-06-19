extends Window


func _ready() -> void:
	$Jingle.play()


func _on_close_requested() -> void:
	queue_free()
