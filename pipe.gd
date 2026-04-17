extends Node2D
class_name Pipe
@onready var up: Area2D = %up
@onready var down: Area2D = %down
@onready var timer: Timer = $Timer
signal send_pipe()

var time := 0.0
var start_y:=0.0
var up_start_y = 0.0
var down_start_y = 0.0
var is_updown:=true
var is_inout:=false
var send:=true
var speed:=100.0
@export var amplitude = 80.0  # How far up/down it goes
@export var frequency = 2.0  # How fast it moves

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	randomize()
	up_start_y = up.position.y  # store original position
	down_start_y= down.position.y
	start_y=position.y
	if is_multiplayer_authority():
		var t = randf_range(0.0, 1000.0)
		selecte_random.rpc(t)
		
@rpc("any_peer", "call_local")
func selecte_random(t: float) -> void:
	time = t	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return

	if Input.is_action_just_pressed("lock"):
		if is_updown:
			set_pipe_mode.rpc(1)
		elif is_inout:
			set_pipe_mode.rpc(2)
			
func _process(delta: float) -> void:
	time += delta

	if is_updown:
		_up_down_local()
	elif is_inout:
		_in_out_local()
	else:
		position.x -= speed * delta
		if send:
			send_pipe.emit()
			send = false

	if global_position.x < -20:
		queue_free()
		
func _up_down_local() -> void:
	position.y = start_y + sin(time * frequency) * amplitude

func _in_out_local() -> void:
	var offset = pow(sin(time * frequency), 2) * amplitude
	up.position.y = up_start_y - offset
	down.position.y = down_start_y + offset

func _on_timer_timeout() -> void:
	if !is_multiplayer_authority():
		return
	
	send_pipe_now.rpc()
	
	
@rpc("any_peer", "call_local")
func set_pipe_mode(mode: int) -> void:
	match mode:
		0:
			is_updown = true
			is_inout = false
		1:
			is_updown = false
			is_inout = true
		2:
			is_updown = false
			is_inout = false
@rpc("any_peer", "call_local")
func send_pipe_now() -> void:
	is_updown = false
	is_inout = false
