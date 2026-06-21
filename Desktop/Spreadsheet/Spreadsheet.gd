extends Window


@onready var sheet = $Sheet


func _ready() -> void:
	Master.openWindows["spreadsheet"] += 1
	if Master.storyKeys["sheetEntries"] == []:
		return
	for i in range(36):
		sheet.get_child(i).fill(Master.storyKeys["sheetEntries"][i])


func _process(_delta: float) -> void:
	if Master.primaryWindows["spreadsheet"] == null:
		Master.primaryWindows["spreadsheet"] = self


func _on_close_requested() -> void:
	var info = []
	for child : CellPair in sheet.get_children():
		info.append(child.entry)
	Master.storyKeys["sheetEntries"] = info
	Master.checkSheet()
	Master.openWindows["spreadsheet"] -= 1
	queue_free()
