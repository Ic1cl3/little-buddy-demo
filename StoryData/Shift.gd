class_name Shift
extends StoryEvent


@export var position : Vector2
@export_range(0, 10, 0.05, "or_greater", "suffix: seconds") var time : float
@export var relative : bool
