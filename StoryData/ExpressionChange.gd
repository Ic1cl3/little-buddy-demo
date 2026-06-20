class_name ExpressionChange
extends StoryEvent


enum expressions {
	EMOTION,
	CRAZY_STRENGTH,
	CLOSENESS,
	CRAZYNESS,
}


@export var change : expressions
@export_range(-0.8, 1, 0.01, "or_greater", "or_less") var value : float
@export_range(0, 300, 0.01, "or_greater", "suffix: seconds") var time : float
