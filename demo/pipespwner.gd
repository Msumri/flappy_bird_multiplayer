extends Node2D
@export var pipe_obj:PackedScene
var currentpipe:Pipe
@onready var pipe_timer: Timer = $Timer

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	global_position=Vector2(278,200)
	await get_tree().process_frame
	if is_multiplayer_authority():
		spawn_pipe.rpc()

# Called when the node enters the scene tree for the first time.
@rpc("any_peer","call_local")
func spawn_pipe():
	var pipes = pipe_obj.instantiate()
	pipes.set_multiplayer_authority(name.to_int())
	add_child(pipes)
	pipes.send_pipe.connect(_on_pipe_sent)

	
func _on_pipe_sent():
	if is_multiplayer_authority():
		pipe_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_timer_timeout() -> void:
	spawn_pipe.rpc()
