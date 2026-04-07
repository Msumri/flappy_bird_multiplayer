extends Node2D

@export var pipe_obj :PackedScene
var time_between:=2.0
var allow_new_pipe:=false
func _ready() -> void:
	spawn_pipe()
func _process(delta: float) -> void:
	time_between-=delta
	
		
	if time_between<=0:
		allow_new_pipe=true
		time_between=2
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("lock"):
		spawn_pipe()		
		
func spawn_pipe():
	var pipe = pipe_obj.instantiate()
	
	add_child(pipe)
	pipe.send_pipe.connect(_on_pipe_sent)

func _on_pipe_sent():
	spawn_pipe()
