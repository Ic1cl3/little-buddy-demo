@tool
class_name InboxMessage
extends MarginContainer


@export var from : String = ""
@export var subject : String = ""
@export var unread : bool = true


func _process(_delta: float) -> void:
	var seg1
	if unread:
		seg1 = "[New!] "
	else:
		seg1 = ""
	$Parent/Info.text = seg1 + from + " - " + "\"" + subject + "\""
