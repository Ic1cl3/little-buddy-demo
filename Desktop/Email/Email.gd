extends Window


@onready var toPicker = $TabContainer/SendMail/OptionButton
@onready var messageEdit = $TabContainer/SendMail/TextEdit
@onready var spreadsheetAttacher = $TabContainer/SendMail/Spreadsheet
@onready var send = $Send
@onready var choose = $Choose
@onready var attach = $Attach
@onready var inbox : VBoxContainer = $TabContainer/GetMail/VBoxContainer
@onready var newCountDisplay = $TabContainer/GetMail/VBoxContainer/Info


var spreadsheetAttached = false
var prevFrameSelected = 0


func _ready() -> void:
	Master.openWindows["email"] += 1
	refreshInbox()
	Master.emailed.connect(refreshInbox)


func _process(_delta: float) -> void:
	if Master.primaryWindows["email"] == null:
		Master.primaryWindows["email"] = self
	
	if prevFrameSelected != toPicker.selected:
		prevFrameSelected = toPicker.selected
		choose.play()
	
	if spreadsheetAttached:
		spreadsheetAttacher.text = "Spreadsheet Attached"
	else:
		spreadsheetAttacher.text = "Attach Spreadsheet"
	
	var newCount = 0
	for child in inbox.get_children():
		if child is InboxMessage:
			if child.unread:
				newCount += 1
	if newCount == 0:
		newCountDisplay.text = " No new messages"
	elif newCount == 1:
		newCountDisplay.text = " 1 new message"
	else:
		newCountDisplay.text = " " + str(newCount)  + " new messages"


func refreshInbox() -> void:
	if inbox.get_child_count() - 1 == len(Master.storyKeys["inbox"]):
		return
	else:
		var messagesToAdd = []
		for i in range(len(Master.storyKeys["inbox"]) - inbox.get_child_count() + 1):
			var messageScene : PackedScene = load("res://Desktop/Email/InboxMessage.tscn")
			var messageNode : InboxMessage = messageScene.instantiate()
			messageNode.incoming = Master.storyKeys["inbox"][inbox.get_child_count() - 1 + i]
			messagesToAdd.append(messageNode)
		for messageToAdd in messagesToAdd:
			inbox.add_child(messageToAdd)
			inbox.move_child(messageToAdd, 1)


func _on_close_requested() -> void:
	Master.openWindows["email"] -= 1
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
	Master.emit_signal("sent")
	await get_tree().create_timer(0.8).timeout
	messageEdit.text = ""
