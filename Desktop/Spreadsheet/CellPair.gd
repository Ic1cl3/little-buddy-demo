@tool
class_name CellPair
extends Control


@export var LeftVal : String = ""
var entry = ""


func _process(_delta: float) -> void:
	$LeftSide.text = LeftVal
	entry = $RightSide.text


func fill(oldText : String) -> void:
	$RightSide.text = oldText
