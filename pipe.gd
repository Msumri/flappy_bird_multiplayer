extends Node2D
class_name Pipe
@onready var up: Area2D = %up
@onready var down: Area2D = %down
@onready var timer: Timer = $Timer
signal send_pipe()
signal Gameover()
signal point()
var time := 0.0
var start_y:=0.0
var up_start_y = 0.0
var down_start_y = 0.0
var is_updown:=true
var is_inout:=false
var send:=true
var speed:=50.0
@export var amplitude = 80.0  # How far up/down it goes
@export var frequency = 2.0  # How fast it moves

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	up_start_y = up.position.y  # store original position
	down_start_y= down.position.y
	start_y=position.y
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if is_updown:
		Up_down()
	elif is_inout:
		in_out()
	if  !is_updown and !is_inout:
		position.x-=speed*delta
		if send:
			send_pipe.emit()
			send=false
	if global_position.x <-20:
		queue_free()
		
func in_out():
	var offset = pow(sin(time * frequency), 2) * amplitude	
	up.position.y=up_start_y - offset
	down.position.y=down_start_y +offset
	
func Up_down():
	position.y= start_y+sin(time * frequency) * amplitude


func _on_up_body_entered(body: Node2D) -> void:
	Gameover.emit() # Replace with function body.


func _on_down_body_entered(body: Node2D) -> void:
	Gameover.emit()


func _on_score_body_entered(body: Node2D) -> void:
	point.emit()


func _on_timer_timeout() -> void:
	is_updown=false
	is_inout=false
