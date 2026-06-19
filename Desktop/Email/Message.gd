class_name Message
extends Resource


enum recipients {
	BOSS,
	WIFE
}


@export var text : String = ""
@export var recipient : recipients = recipients.BOSS
@export var spreadsheet : bool = false
