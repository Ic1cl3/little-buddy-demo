extends Node
## Master class.


var storyKeys : Dictionary = {
	"pongData" : null,
	"sheetEntries" : [],
}


func _ready() -> void:
	addWindow("res://Menu/Menu.tscn", true)


func addWindow(scenePath : String, forceNative = false, parent = self) -> void:
	var scene = load(scenePath)
	var node : Window = scene.instantiate()
	node.hide()
	parent.add_child(node)
	if forceNative:
		node.force_native = true
	node.show()
