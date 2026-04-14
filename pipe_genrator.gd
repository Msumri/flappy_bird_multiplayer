extends Node2D
@onready var pipe_timer: Timer = %pipe_timer
@onready var replay: Button = %replay

@export var scores:Array[Texture2D]=[]
@export var pipe_obj :PackedScene
var time_between:=2.0
var currentpipe:Pipe
var score:int=0
var is_pipe=true
var just_started=true
func _ready() -> void:

	$"../ground/AnimationPlayer".play("ground")
	if multiplayer.is_server():
		replay.disabled=false
	else:
		replay.disabled=true
		replay.text="Waiting on Host"


func _input(event: InputEvent) -> void:
	if is_pipe:
		if Input.is_action_just_pressed("lock"):
			if currentpipe==null and just_started:
				spawn_pipe.rpc()
				just_started=false
			elif currentpipe and not currentpipe.is_updown1:
				currentpipe.is_inout.rpc(false)
			else:
				currentpipe.is_inout.rpc(true)
				currentpipe.is_updown.rpc(false)
		
@rpc("any_peer","call_local")		
func spawn_pipe():
	var pipes = pipe_obj.instantiate()
	add_child(pipes)
	currentpipe=pipes
	currentpipe.send_pipe.connect(_on_pipe_sent)
	currentpipe.Gameover.connect(_on_game_over)
	currentpipe.point.connect(_on_point)

func _on_pipe_sent():
	if is_pipe:
		pipe_timer.start()

@rpc("any_peer","call_local")	
func _on_game_over():
	get_tree().paused = true
	%gameover.show()
	if score<10:
		%finalscorebird1.texture=scores[score]
	elif score<100:
		%finalscorebird2.show()
		%finalscorebird1.texture=scores[int(str(score)[0])]
		%finalscorebird2.texture=scores[int(str(score)[1])]
	elif score>99:
		%finalscorebird2.show()
		%finalscorebird3.show()
		%finalscorebird1.texture=scores[int(str(score)[0])]
		%finalscorebird2.texture=scores[int(str(score)[1])]	
		%finalscorebird3.texture=scores[int(str(score)[2])]	
		
	print("you lost	")
func _on_point():
	score+=1
	print(score)
	if score<10:
		%score.texture=scores[score]
	elif score<100:
		%score2.show()
		%score.texture=scores[int(str(score)[0])]
		%score2.texture=scores[int(str(score)[1])]
	elif score>99:
		%score2.show()
		%score3.show()
		%score.texture=scores[int(str(score)[0])]
		%score2.texture=scores[int(str(score)[1])]	
		%score3.texture=scores[int(str(score)[2])]	
		
func _on_timer_timeout() -> void:
	spawn_pipe.rpc()
	


func _on_ground_body_entered(body: Node2D) -> void:
	_on_game_over()

@rpc("authority", "call_local")
func set_team(cond:bool) -> void:
	is_pipe=cond
	just_started=cond
@rpc("call_local")
func reset_scene():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_replay_pressed() -> void:
	reset_scene.rpc()
