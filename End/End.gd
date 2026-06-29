extends Window


@onready var tbc = $Back/Label
@onready var back = $Back


func _ready() -> void:
	tbc.hide()
	await get_tree().create_timer(3).timeout
	back.hide()
	tbc.show()
	await get_tree().create_timer(6).timeout
	back.show()
	await get_tree().create_timer(4).timeout
	get_tree().quit()
