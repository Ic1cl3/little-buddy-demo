extends Window


@onready var toPicker = $TabContainer/SendMail/OptionButton
@onready var messageEdit = $TabContainer/SendMail/TextEdit
@onready var spreadsheetAttacher = $TabContainer/SendMail/Spreadsheet
@onready var send = $Send
@onready var choose = $Choose
@onready var attach = $Attach


var spreadsheetAttached = false
var prevFrameSelected = 0


func _process(_delta: float) -> void:
	if prevFrameSelected != toPicker.selected:
		prevFrameSelected = toPicker.selected
		choose.play()
	
	if spreadsheetAttached:
		spreadsheetAttacher.text = "Spreadsheet Attached"
	else:
		spreadsheetAttacher.text = "Attach Spreadsheet"


func _on_close_requested() -> void:
	queue_free()


func _on_spreadsheet_pressed() -> void:
	spreadsheetAttached = !spreadsheetAttached
	attach.play()


func _on_send_pressed() -> void:
	var message = Message.new()
	message.recipient = toPicker.selected
	message.text = messageEdit.text
	message.spreadsheet = spreadsheetAttached
	Master.storyKeys["emails"].append(message)
	messageEdit.text = "Sent!"
	send.play()
	await get_tree().create_timer(0.8).timeout
	messageEdit.text = ""
