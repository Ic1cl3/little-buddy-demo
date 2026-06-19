@tool
class_name RecievedMessage
extends Window


@export var incoming : IncomingMail


@onready var from = $From
@onready var text = $Text


func _process(_delta: float) -> void:
	if incoming == null:
		return
	if incoming.from == 0:
		from.text = "Boss"
	else:
		from.text = "Wife"
	text.text = incoming.text


func _on_close_requested() -> void:
	queue_free()
