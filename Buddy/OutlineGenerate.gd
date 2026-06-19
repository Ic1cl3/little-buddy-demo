@tool
extends Polygon2D


const speed = 25
var time = 0.0
var sieze = 0.0


func _process(delta: float) -> void:
	time += delta
	polygon = get_parent().points
	var newUV = []
	for vectorIndex in len(polygon):
		var vector = polygon[vectorIndex]
		if vectorIndex % 8 <= 3:
			vector *= 1.2
			if vectorIndex % 8 == 1 or vectorIndex % 8 == 2:
				vector *= 1.15
		var vTransform = (vector + Vector2(74, 74) + sieze*Vector2(randf(), randf()))
		newUV.append(vTransform)
	uv = newUV
	var direction = Vector3(time, time + 4*time*sin(0.5*time), 0).normalized()
	texture.noise.offset += direction * speed * delta
