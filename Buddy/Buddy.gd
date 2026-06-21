class_name Buddy
extends Window


signal haltFinished


const shapes : Shapes = preload("res://Buddy/Shapes.tres")
var storyData : StoryData = preload("res://StoryData/Story.tres")
var blinkTimer = 7.0
var bind : SetBind.binds
var lastFrameBindable = false
var enteringBind = false
var morphing = false
var skipCount = 0
@onready var animTree : AnimationTree = $AnimationTree
@onready var outline = $Outline
@onready var mouthi : mouth = $Mouth


func _ready() -> void:
	await get_tree().process_frame
	while shapes == null:
		await get_tree().process_frame
	Master.test.connect(test)
	shift(1.25, 0.75, 0)
	for event : StoryEvent in storyData.events:
		if skipCount > 0:
			skipCount -= 1
			continue
		if event.parallel:
			parseEvent(event)
		else:
			await parseEvent(event)


func _process(delta: float) -> void:
	visible = get_parent().visible
	blinkTimer -= delta
	if blinkTimer <= 0:
		blink()
		blinkTimer = randf_range(7, 12)
	if bind == SetBind.binds.NONE:
		return
	else:
		var target : String
		if bind == SetBind.binds.PONG:
			target = "pong"
		elif bind == SetBind.binds.SPREADSHEET:
			target = "spreadsheet"
		else:
			target = "email"
		if Master.primaryWindows[target] == null:
			return
		var site = Master.primaryWindows[target]
		var yOffset = site.size.y/2
		var shiftDelay = 0.2
		if site is Pong and Master.storyKeys["pongData"] != null and Master.storyKeys["yayGame"]:
			yOffset = Master.storyKeys["pongData"]
			shiftDelay = 0
			if not morphing:
				morph("Pong", 1)
		shift(site.position.x + site.size.x + 100, site.position.y + yOffset, shiftDelay, false)


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
	morphing = true
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(outline, "points", shapes.shapes[shape], transitionTime)
	await tween.finished
	tween.stop()
	tween.tween_callback(queue_free)
	morphing = false
	return


func shift(newPosX : float, newPosY : float, time : float = 1, relative : bool = true) -> void:
	var newPos = Vector2(newPosX, newPosY)
	var nextPos : Vector2i
	if relative:
		@warning_ignore("narrowing_conversion")
		nextPos = Vector2i(newPos * Vector2(get_parent().size))
	else:
		nextPos = Vector2i(newPos)
	@warning_ignore("integer_division")
	nextPos -= size/2
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", nextPos, time)
	await tween.finished
	tween.stop()
	tween.tween_callback(queue_free)
	return


func finishHalt() -> void:
	emit_signal("haltFinished")


func parseEvent(event: StoryEvent) -> void:
	if event is CallDelayed:
		await get_tree().create_timer(event.length).timeout
		await parseEvent(event.delayedCall)
		return
	elif event is Delay:
		await get_tree().create_timer(event.length).timeout
		return
	elif event is ExpressionChange:
		if event.change == ExpressionChange.expressions.EMOTION:
			await set_emotion(event.value, event.time)
		elif event.change == ExpressionChange.expressions.CRAZY_STRENGTH:
			await set_CrazyStrength(event.value, event.time)
		elif event.change == ExpressionChange.expressions.CLOSENESS:
			await set_Closeness(event.value, event.time)
		elif event.change == ExpressionChange.expressions.CRAZYNESS:
			await set_Crazyness(event.value, event.time)
		return
	elif event is HaltUntilParam:
		while not Master.storyKeys[event.paramName] == event.value:
			await get_tree().process_frame
		return
	elif event is IfDo:
		if Master.storyKeys[event.paramName] == event.value:
			await parseEvent(event.do)
		return
	elif event is IfJump:
		if Master.storyKeys[event.paramName] == event.value:
			skipCount += event.skipAmount
		return
	elif event is MailTrigger:
		Master.sendEmail(event.message, event.delay)
		await get_tree().create_timer(event.delay).timeout
		return
	elif event is MasterSignalEmit:
		Master.emit_signal(event.signalName)
		return
	elif event is MasterSignalHalt:
		Master.connect(event.signalName, finishHalt)
		await haltFinished
		return
	elif event is Morph:
		await morph(event.shapeName)
		return
	elif event is SetBind:
		bind = event.newBind
		return
	elif event is SetParam:
		Master.storyKeys[event.paramName] = event.value
		return
	elif event is Shift:
		await shift(event.position.x, event.position.y, event.time, event.relative)
		return
	elif event is VoiceQueue:
		await mouthi.speak(event.voiceline)
		return


func test():
	print("tested!")


func beBinded():
	enteringBind = false
