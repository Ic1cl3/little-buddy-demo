class_name Buddy
extends Node2D


@export var shapes : Shapes = preload("res://Buddy/Shapes.tres")
@onready var animTree : AnimationTree = $AnimationTree
@onready var outline = $Outline


func _ready() -> void:
	outline.points = shapes.shapes["Default"]


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
	tween.tween_property(outline, "points", shapes.shapes[shape], transitionTime)
	await tween.finished
	tween.stop()
	tween.tween_callback(queue_free)
	return
