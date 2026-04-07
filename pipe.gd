extends Node2D

@onready var up: Area2D = %up
@onready var down: Area2D = %down
signal send_pipe()
var time := 0.0
var start_y:=0.0
var up_start_y = 0.0
var down_start_y = 0.0
var is_updown:=false
var is_inout:=false
var send:=false
@export var amplitude = 100.0  # How far up/down it goes
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
	if send:
		position.x-=50*delta
		

func in_out():
	var offset = pow(sin(time * frequency), 2) * amplitude	
	up.position.y=up_start_y - offset
	down.position.y=down_start_y +offset
	
func Up_down():
	position.y= start_y+sin(time * frequency) * amplitude
