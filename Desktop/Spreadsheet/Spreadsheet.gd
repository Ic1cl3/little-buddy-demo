extends Window


@onready var sheet = $Sheet


func _ready() -> void:
	if Master.storyKeys["sheetEntries"] == []:
		return
	for i in range(36):
		sheet.get_child(i).fill(Master.storyKeys["sheetEntries"][i])


func _on_close_requested() -> void:
	var info = []
	for child : CellPair in sheet.get_children():
		info.append(child.entry)
	Master.storyKeys["sheetEntries"] = info
	queue_free()
