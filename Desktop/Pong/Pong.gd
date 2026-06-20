class_name Pong
extends Window


@onready var ball = $Ball
@onready var leftPaddle = $Paddle1
@onready var rightPaddle = $Paddle2
@onready var bounce = $Bounce
@onready var win = $Win
@onready var lose = $Lose


var leftscore = 0
var rightscore = 0


func _ready() -> void:
	Master.openWindows["pong"] += 1
	resetBall()


func _physics_process(_delta: float) -> void:
	if Master.primaryWindows["pong"] == null:
		Master.primaryWindows["pong"] = self
	ball.velocity = ball.velocity.normalized() * 400
	ball.move_and_slide()
	leftPaddle.position.y = get_mouse_position().y
	rightPaddle.position.y = ball.position.y
	if ball.position.x < -16:
		rightscore += 1
		resetBall()
		lose.play()
	if ball.position.x > 528:
		leftscore += 1
		resetBall()
		win.play()
	$Leftscore.text = str(leftscore)
	$Rightscore.text = str(rightscore)


func resetBall() -> void:
	ball.velocity = Vector2(randi_range(3, 10) * ((randi_range(0, 1)*2)-1), randi_range(3, 10) * ((randi_range(0, 1)*2)-1))
	ball.velocity = ball.velocity.normalized()
	ball.position = Vector2(256, 256)


func _on_close_requested() -> void:
	Master.openWindows["pong"] -= 1
	queue_free()


func _on_left_paddle_body_entered(_body: Node2D) -> void:
	bounce.play()
	var rads = (PI*(ball.position.y - leftPaddle.position.y)/64)
	ball.velocity = (ball.velocity.normalized() + Vector2(cos(rads), sin(rads)).normalized()).normalized() * 400
	ball.move_and_slide()


func _on_right_paddle_body_entered(_body: Node2D) -> void:
	bounce.play()
	var rads = (PI*(ball.position.y - rightPaddle.position.y)/64)
	ball.velocity = (ball.velocity.normalized() + Vector2(cos(rads + PI), sin(rads + PI)).normalized()).normalized() * 400
	ball.move_and_slide()


func _on_bottom_edge_body_entered(_body: Node2D) -> void:
	bounce.play()
	ball.velocity.y = -1 * ball.velocity.y
	ball.velocity = ball.velocity.normalized() * 400
	ball.move_and_slide()


func _on_top_edge_body_entered(_body: Node2D) -> void:
	bounce.play()
	ball.velocity.y = -1 * ball.velocity.y
	ball.velocity = ball.velocity.normalized() * 400
	ball.move_and_slide()
