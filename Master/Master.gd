extends Node
## Master class.


signal emailed


var storyKeys : Dictionary = {
	"pongData" : null,
	"sheetEntries" : [],
	"emails" : [],
	"inbox" : []
}


func _ready() -> void:
	addWindow("res://Menu/Menu.tscn", true)
	sendEmail(load("res://StoryData/Emails/Divorced.tres"), 10)
	sendEmail(load("res://StoryData/Emails/Fired.tres"), 20)


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
