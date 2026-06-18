extends Window


@onready var sevenseg = $Sevenseg
@onready var punch = $Punch
@onready var compute = $Compute
@onready var error = $Error


func _ready() -> void:
	sevenseg.text = ""


func _process(_delta: float) -> void:
	var labelLengthOver16 = sevenseg.text.length() - 16
	if labelLengthOver16 < 0: labelLengthOver16 = 0
	sevenseg.add_theme_font_size_override("font_size", 32 - (labelLengthOver16))


func _on_1_pressed() -> void:
	sevenseg.text += "1"
	punch.play()


func _on_2_pressed() -> void:
	sevenseg.text += "2"
	punch.play()


func _on_3_pressed() -> void:
	sevenseg.text += "3"
	punch.play()


func _on_4_pressed() -> void:
	sevenseg.text += "4"
	punch.play()


func _on_5_pressed() -> void:
	sevenseg.text += "5"
	punch.play()


func _on_6_pressed() -> void:
	sevenseg.text += "6"
	punch.play()


func _on_7_pressed() -> void:
	sevenseg.text += "7"
	punch.play()


func _on_8_pressed() -> void:
	sevenseg.text += "8"
	punch.play()


func _on_9_pressed() -> void:
	sevenseg.text += "9"
	punch.play()


func _on_0_pressed() -> void:
	sevenseg.text += "0"
	punch.play()


func _on_add_pressed() -> void:
	sevenseg.text += "+"
	punch.play()


func _on_subtract_pressed() -> void:
	sevenseg.text += "-"
	punch.play()


func _on_multiply_pressed() -> void:
	sevenseg.text += "*"
	punch.play()


func _on_divide_pressed() -> void:
	sevenseg.text += "/"
	punch.play()


func _on_delete_pressed() -> void:
	sevenseg.text = sevenseg.text.substr(0, sevenseg.text.length() - 1)
	punch.play()


func _on_clear_pressed() -> void:
	sevenseg.text = ""
	punch.play()


func _on_compute_pressed() -> void:
	if sevenseg.text.length() == 0:
		return
	if sevenseg.text.length() >= 5 and sevenseg.text.substr(0, 5) == "Error":
		sevenseg.text = ""
		return
	if sevenseg.text[0] == "=":
		sevenseg.text = sevenseg.text.substr(1, -1)
	var solution = 0
	var firstOneDone = false
	var subtractSplit = sevenseg.text.split("-")
	for subtractSlice in subtractSplit:
		var additionSplit = subtractSlice.split("+")
		var localSum = 0
		for additionSlice in additionSplit:
			var multiplicationSplit = additionSlice.split("*")
			var localProduct = 1
			for multiplicationSlice in multiplicationSplit:
				var dotSplit : PackedStringArray = multiplicationSlice.split(".")
				if dotSplit.size() > 2:
					sevenseg.text = "Error"
					error.play()
					return
				for dotSlice in dotSplit:
					if dotSlice.length() == 0:
						sevenseg.text = "Error"
						error.play()
						return
				localProduct *= float(multiplicationSlice)
			localSum += localProduct
		solution -= localSum
		if not firstOneDone:
			firstOneDone = true
			solution += 2 * localSum
	sevenseg.text = "=" + str(solution)
	compute.play()


func _on_close_requested() -> void:
	queue_free()


func _on_dot_pressed() -> void:
	sevenseg.text += "."
	punch.play()
