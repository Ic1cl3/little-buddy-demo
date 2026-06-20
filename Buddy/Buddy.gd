class_name Buddy
extends Window


@export var shapes : Shapes = preload("res://Buddy/Shapes.tres")
@onready var animTree : AnimationTree = $AnimationTree
@onready var outline = $Outline
@onready var mouthi : mouth = $Mouth


func _ready() -> void:
	await get_tree().process_frame
	shift(1.25, 0.75, 0)
	outline.points = shapes.shapes["Default"]
	await get_tree().create_timer(5).timeout
	await shift(0.833, 0.75, 3)
	mouthi.speak(load("res://StoryData/Voicelines/Test.mp3"))


func _process(_delta: float) -> void:
	visible = get_parent().visible


func set_parameter(param : String, value : float = 0, transitionTime : float = 0.2) -> void:
	var tween : Tween = create_tween()
	if param != "Crazyness":
		tween.tween_property(animTree, "parameters/" + param + "/blend_amount", value, transitionTime)
	else:
		tween.tween_property(animTree, "parameters/" + param + "/add_amount", value, transitionTime)
	await tween.finished
	tween.stop()
	tween.tween_callback(queue_free)
	return


func set_emotion(emotion : float, transitionTime : float = 0.2) -> void:
	await set_parameter("Emotion", emotion, transitionTime)
	return


func set_CrazyStrength(strength : float, transitionTime : float = 0.2) -> void:
	await set_parameter("CrazyStrength", strength, transitionTime)
	return


func set_Closeness(closeness : float, transitionTime : float = 0.2) -> void:
	await set_parameter("Closeness", closeness, transitionTime)
	return


func set_Crazyness(crazyness : float, transitionTime : float = 0.2) -> void:
	await set_parameter("Crazyness", crazyness, transitionTime)
	return


func blink() -> void:
	animTree.set("parameters/Blinker/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func morph(shape : String, transitionTime : float = 0.75) -> void:
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(outline, "points", shapes.shapes[shape], transitionTime)
	await tween.finished
	tween.stop()
	tween.tween_callback(queue_free)
	return


func shift(newPosX : float, newPosY : float, time : float = 1, relative : bool = true) -> void:
	var newPos = Vector2(newPosX, newPosY)
	var nextPos : Vector2i
	if relative:
		@warning_ignore("narrowing_conversion")
		nextPos = Vector2i(newPos * Vector2(get_parent().size))
	else:
		nextPos = Vector2i(newPos)
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", nextPos, time)
	await tween.finished
	tween.stop()
	tween.tween_callback(queue_free)
	return
