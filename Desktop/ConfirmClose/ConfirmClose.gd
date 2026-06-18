extends Window


func _ready() -> void:
	$WarnPlayer.play()


func _on_quit_pressed() -> void:
	$ClosePlayer.play()
	await get_tree().create_timer(0.81).timeout
	get_parent().hide()
	await $ClosePlayer.finished
	get_tree().quit()


func _on_dont_quit_pressed() -> void:
	queue_free()


func _on_close_requested() -> void:
	queue_free()
