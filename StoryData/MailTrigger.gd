class_name MailTrigger
extends StoryEvent


@export var message : IncomingMail
@export_range(0, 300, 0.2, "or_greater", "suffix: seconds") var delay : float
