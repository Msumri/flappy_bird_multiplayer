extends Node2D
@export var pipe_obj:PackedScene
var currentpipe:Pipe
@onready var pipe_timer: Timer = $Timer

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	global_position=Vector2(278,200)
	
	if is_multiplayer_authority():
		spawn_pipe.rpc()
func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): return
	if Input.is_action_just_pressed("lock"):
		if !currentpipe:return
		if currentpipe.is_updown:
			currentpipe.is_inout=true
			currentpipe.is_updown=false
			print("aa")
		else:
			print("bb")
			currentpipe.is_inout=false
			currentpipe.is_updown=false
# Called when the node enters the scene tree for the first time.
@rpc("authority","call_local")
func spawn_pipe():
	var pipes = pipe_obj.instantiate()
	add_child(pipes)
	currentpipe=pipes
	currentpipe.send_pipe.connect(_on_pipe_sent)
	currentpipe.Gameover.connect(_on_game_over)
	currentpipe.point.connect(_on_point)

func _on_pipe_sent():
	currentpipe=null
	pipe_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_game_over():
	_death.rpc()
func _on_point():
	pass

@rpc("any_peer","call_local")
func _death():
	print("lost")

func _on_timer_timeout() -> void:
	spawn_pipe.rpc()
