class_name IncomingMail
extends Resource


@export var from : Message.recipients = Message.recipients.BOSS
@export var subject : String = ""
@export_multiline var text : String = ""
@export var unread : bool = true
