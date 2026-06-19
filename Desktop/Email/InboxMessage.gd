@tool
class_name InboxMessage
extends MarginContainer

@export var incoming : IncomingMail
var from : String = ""
var subject : String = ""
var unread : bool = true


func _ready() -> void:
	hide()


func _process(_delta: float) -> void:
	if incoming != null:
		if incoming.from == 0:
			from = "Boss"
		else:
			from = "Wife"
		subject = incoming.subject
		unread = incoming.unread
	var seg1
	if unread:
		seg1 = "[New!] "
	else:
		seg1 = ""
	$Parent/Info.text = seg1 + from + " - " + "\"" + subject + "\""
	show()


func _on_button_pressed() -> void:
	$Open.play()
	var scene = load("res://Desktop/Email/RecievedMessage.tscn")
	var messageBox : RecievedMessage = scene.instantiate()
	incoming.unread = false
	messageBox.incoming = incoming
	get_node("/root/Master/Desktop").add_child(messageBox)
