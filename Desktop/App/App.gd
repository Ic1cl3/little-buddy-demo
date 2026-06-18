@tool
class_name App
extends Node2D


@export var titleString : String
@export var iconImage : Texture2D
@export var windowPath : String


var title : Label
var icon : Sprite2D
var focusGrabber : ColorRect
var hover : bool = false
var time = 0


func _process(delta: float) -> void:
	# Don't prematurely detect a lack of nodes and duplicate shit.
	time += delta
	if time < 0.1: return
	# Handle icon node existance.
	if icon == null and iconImage != null:
		if get_child_count() < 3:
			icon = Sprite2D.new()
			add_child(icon)
			icon.owner = get_tree().edited_scene_root
		else:
			for child in get_children():
				if child is Sprite2D:
					if icon != null:
						child.queue_free()
						break
					icon = child
	elif icon != null and iconImage == null:
		icon.queue_free()
	elif icon != null and iconImage != null:
		icon.texture = iconImage
	# Handle label node existance.
	if title == null:
		if get_child_count() < 3:
			title = Label.new()
			title.theme = load("res://Theme.tres")
			add_child(title)
			title.owner = get_tree().edited_scene_root
		else:
			for child in get_children():
				if child is Label:
					if title != null:
						child.queue_free()
						break
					title = child
	else:
		title.text = titleString
		title.position.x = -title.size.x/2
		if iconImage != null:
			@warning_ignore("integer_division")
			title.position.y = (iconImage.get_height()/2) + 4
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# Handle the focus grabber.
	if focusGrabber == null:
		if get_child_count() < 3:
			focusGrabber = ColorRect.new()
			focusGrabber.color = Color.TRANSPARENT
			add_child(focusGrabber)
			focusGrabber.owner = get_tree().edited_scene_root
		else:
			for child in get_children():
				if child is ColorRect:
					if focusGrabber != null:
						child.queue_free()
						break
					focusGrabber = child
	else:
		if iconImage != null:
			focusGrabber.size = Vector2(iconImage.get_width() + 20, iconImage.get_height() + 26)
			focusGrabber.position.x = -focusGrabber.size.x/2
			@warning_ignore("integer_division")
			focusGrabber.position.y = -iconImage.get_height()/2 - 5
	var mouse = get_local_mouse_position()
	var grab = focusGrabber.size
	hover = mouse.x < grab.x/2 and mouse.x > -grab.x/2 and mouse.y > focusGrabber.position.y and mouse.y < focusGrabber.position.y + grab.y
	if hover:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		if iconImage != null and is_equal_approx(icon.scale.x, 1):
			create_tween().tween_property(icon, "scale", Vector2(1.13, 1.13), 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		if Input.is_action_just_released("lmb"):
			Master.addWindow(windowPath, false, get_parent())
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		if iconImage != null and is_equal_approx(icon.scale.x, 1.13):
			create_tween().tween_property(icon, "scale", Vector2.ONE, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
