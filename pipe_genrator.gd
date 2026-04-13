extends Node2D
@onready var pipe_timer: Timer = %pipe_timer
@export var scores:Array[Texture2D]=[]
@export var pipe_obj :PackedScene
var time_between:=2.0
var currentpipe:Pipe
var score:int=0
var is_pipe=false
func _ready() -> void:
	currentpipe=spawn_pipe()
	currentpipe.send_pipe.connect(_on_pipe_sent)
	currentpipe.Gameover.connect(_on_game_over)
	currentpipe.point.connect(_on_point)
	$"../ground/AnimationPlayer".play("ground")
func _input(event: InputEvent) -> void:
	if is_pipe:
		if Input.is_action_just_pressed("lock"):
			if currentpipe and not currentpipe.is_updown:
				currentpipe.is_inout=false
			else:
				currentpipe.is_inout=true
				currentpipe.is_updown=false	
				
		
func spawn_pipe():
	var pipe = pipe_obj.instantiate()
	add_child(pipe)
	return pipe
func _on_pipe_sent():
	pipe_timer.start()

func _on_game_over():
	get_tree().paused = true
	%gameover.show()

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
	currentpipe=spawn_pipe()
	currentpipe.send_pipe.connect(_on_pipe_sent)
	currentpipe.Gameover.connect(_on_game_over)
	currentpipe.point.connect(_on_point)


func _on_ground_body_entered(body: Node2D) -> void:
	_on_game_over()
