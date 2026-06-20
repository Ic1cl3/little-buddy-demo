class_name mouth
extends Line2D


var defaultPoints = [
	Vector2(-20, 0),
	Vector2(-16, 0),
	Vector2(-12, 0),
	Vector2(-8, 0),
	Vector2(-4, 0),
	Vector2(0, 0),
	Vector2(4, 0),
	Vector2(8, 0),
	Vector2(12, 0),
	Vector2(16, 0),
	Vector2(20, 0),
]
var speaking : bool = false


@onready var player = $MessagePlayer


func _process(_delta: float) -> void:
	if not speaking:
		points = PackedVector2Array(defaultPoints)
	else:
		points = PackedVector2Array(getRandomHeights())


func getRandomHeights() -> Array[Vector2]:
	var output : Array[Vector2] = [Vector2(-20, 0), Vector2(-16, 0), Vector2(16, 0), Vector2(20, 0)]
	for i in range(7):
		output.insert(2, Vector2(defaultPoints[i + 2].x, randf_range(-4.0, 4.0)))
	return output


func speak(message : AudioStream) -> void:
	player.stream = message
	speaking = true
	player.play()
	await player.finished
	speaking = false
	return
