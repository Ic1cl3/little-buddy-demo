@tool
class_name RecievedMessage
extends Window


@export var incoming : IncomingMail


var finalSubjects : Array = [
	"Termination",
	"Good Work Today",
	"Exceptional Work"
]


@onready var from = $From
@onready var text = $Text


func _ready() -> void:
	var final = false
	for possible in finalSubjects:
		if incoming.subject == possible:
			final = true
	if final:
		print("bs")
		Master.storyKeys["endingRead"] = true
		Master.divorcedCheck()


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
