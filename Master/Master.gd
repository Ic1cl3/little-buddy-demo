extends Node
## Master class.


signal emailed
signal clockedIn
signal prepareEnding
@warning_ignore("unused_signal")
signal sent
@warning_ignore("unused_signal")
signal test


var storyKeys : Dictionary = {
	"pongData" : null,
	"sheetEntries" : [],
	"emails" : [],
	"inbox" : [],
	"rabbit" : false,
	"yayGame" : true,
	"testParam" : false,
	"emailOpen" : false,
	"pongOpen" : false,
	"spreadsheetOpen" : false,
	"emailOrPongOpen" : false,
	"spreadsheetOrPongOpen" : false,
	"finishedWork" : false,
	"score" : false,
	"divorce" : false,
	"fired" : false,
	"likePong" : false,
	"endingRead" : false,
	"goTime" : false
}

var openWindows : Dictionary = {
	"pong" : 0,
	"spreadsheet" : 0,
	"email" : 0,
}

var primaryWindows : Dictionary = {
	"pong" : null,
	"spreadsheet" : null,
	"email" : null
}

var sheetAnswers = [
	6.5, 3, 6.5,
	0, 7, 6,
	3.25, 4, 17,
	13, 7, 3.25,
	16.25, 15, 19,
	6.5, 0, 9.75,
	16.25, 101, 0,
	6.5,  9, 11,
	39, 47, 22.75,
	26, 27, "RABBIT",
	29.25, 41, 31,
	3.25, 0, 19.5
]


func _ready() -> void:
	addWindow("res://Menu/Menu.tscn", true)
	clockedIn.connect(checkEmail)
	prepareEnding.connect(endEmail)


func _process(_delta: float) -> void:
	if primaryWindows["pong"] != null:
		storyKeys["pongData"] = primaryWindows["pong"].rightPaddle.position.y
	storyKeys["emailOpen"] = openWindows["email"] > 0
	storyKeys["pongOpen"] = openWindows["pong"] > 0
	storyKeys["spreadsheetOpen"] = openWindows["spreadsheet"] > 0
	storyKeys["emailOrPongOpen"] = storyKeys["emailOpen"] or storyKeys["pongOpen"]
	storyKeys["spreadsheetOrPongOpen"] = storyKeys["spreadsheetOpen"] or storyKeys["pongOpen"]


func addWindow(scenePath : String, forceNative = false, parent = self) -> void:
	var scene = load(scenePath)
	var node : Window = scene.instantiate()
	node.hide()
	parent.add_child(node)
	if forceNative:
		node.force_native = true
	node.show()


func sendEmail(email : IncomingMail, delay : float = 0):
	await get_tree().create_timer(delay).timeout
	storyKeys["inbox"].append(email)
	emit_signal("emailed")
	addWindow("res://Desktop/Email/GotMail.tscn", false, $Desktop)


func checkSheet() -> float:
	var points = 0.0
	var anyEmpty = false
	for i in range(len(storyKeys["sheetEntries"])):
		if str(storyKeys["sheetEntries"][i]) == "":
			anyEmpty = true
			continue
		if str(sheetAnswers[i]) in str(storyKeys["sheetEntries"][i]).to_upper():
			points += 1.0
			if i == 29:
				storyKeys["rabbit"] = true
	storyKeys["score"] = points/36
	storyKeys["finishedWork"] = not anyEmpty
	if points/36 < 0.6:
		storyKeys["fired"] = true
	return (points/36)


func checkEmail():
	var email : Message = storyKeys["emails"][len(storyKeys["emails"]) - 1]
	var steamyStrings = ["SEX", "PENIS", "PUSSY", "SUCK", "CUM", "ORGASM", "FUCK YOU", "COCK", "DICK", "LOVE", "HEART", "AFFAIR", "CHEAT", "WIFE", "HUSBAND", "BABY"]
	var strongStrings = ["FUCK", "DAMN", "SHIT", "ASS", "CUNT", "IDIOT", "LARP", "RETARD"]
	var steamy = false
	var strong = false
	for string in steamyStrings:
		if string in email.text.to_upper():
			steamy = true
			strong = true
	for string in  strongStrings:
		if string in email.text.to_upper():
			strong = true
	if email.recipient == Message.recipients.WIFE:
		if strong:
			sendEmail(load("res://StoryData/Emails/HoneyWhat.tres"), 30)
		else:
			sendEmail(load("res://StoryData/Emails/Honey.tres"), 30)
	else:
		if steamy:
			storyKeys["divorced"] = true
		if strong:
			sendEmail(load("res://StoryData/Emails/Problem.tres"), 30)
		else:
			sendEmail(load("res://StoryData/Emails/Thanks.tres"), 30)


func endEmail():
	var fired = storyKeys["fired"]
	var score = storyKeys["score"]
	if fired:
		sendEmail(load("res://StoryData/Emails/Fired.tres"), 40)
		return
	else:
		if score == 1:
			sendEmail(load("res://StoryData/Emails/Wow.tres"), 40)
		else:
			sendEmail(load("res://StoryData/Emails/Pass.tres"), 40)


func divorcedCheck():
	print("foo")
	if storyKeys["divorce"]:
		print("foo")
		sendEmail(load("res://StoryData/Emails/Divorced.tres"), 10)


func doGo():
	await get_tree().create_timer(3).timeout
	addWindow("res://Threshold/Threshhold.tscn", true)
