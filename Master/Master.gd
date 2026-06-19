extends Node
## Master class.


signal emailed


var storyKeys : Dictionary = {
	"pongData" : null,
	"sheetEntries" : [],
	"emails" : [],
	"inbox" : [],
	"rabbit" : false
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
	6.5, 3.0, 6.5,
	0.0, 7.0, 6.0,
	3.25, 4.0, 17.0,
	13.0, 7.0, 3.25,
	16.25, 15.0, 19.0,
	6.5, 0.0, 9.75,
	16.25, 101.0, 0.0,
	6.5,  9.0, 11.0,
	39.0, 47.0, 22.75,
	26.0, 27.0, "rabbit",
	29.25, 41.0, 31.0,
	3.25, 0.0, 19.5
]


func _ready() -> void:
	addWindow("res://Menu/Menu.tscn", true)
	sendEmail(load("res://StoryData/Emails/Quote.tres"), 10)


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
	for i in range(len(storyKeys["sheetEntries"])):
		if sheetAnswers[i] in str(storyKeys["sheetEntries"][i]).to_upper():
			points += 1.0
			if i == 29:
				storyKeys["rabbit"] = true
	return (points/36)
