extends Window


var started : bool = false


@onready var Clock = $BottomBar/Off/Clock
@onready var music = $Music


var normalTime = true
var normalOffAbility = true


func _process(_delta: float) -> void:
	if not music.playing:
		music.play()
	# Assign time label
	var currentTime = Time.get_datetime_dict_from_system()
	if normalTime:
		Clock.text = str(((currentTime["hour"] - 1) % 12) + 1) + ":" + str(currentTime["minute"])


func _on_texture_button_pressed() -> void:
	if normalOffAbility:
		Master.addWindow("res://Desktop/ConfirmClose/ConfirmClose.tscn", false, self)
