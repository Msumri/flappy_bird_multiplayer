extends Node2D
@export var scores:Array[Texture2D]=[]
@onready var replay: Button = %replay
@onready var select_roll: Label = %selectRoll
@onready var birdb: TextureButton = %bird
@onready var pipb: TextureButton = %pip
@onready var animation_player: AnimationPlayer = $ground/AnimationPlayer
@onready var are_you_sure: CanvasLayer = %"are you sure"

var bird:Bird
var score:=0
var game_over:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	animation_player.play("ground")
	if multiplayer.is_server():
		replay.disabled=false
		birdb.disabled=false
		pipb.disabled=false
	else:
		replay.disabled=true
		select_roll.text="Waiting on Host"
		replay.text="Waiting on Host"
		birdb.disabled=true
		pipb.disabled=true
func _process(delta: float) -> void:
	if !bird:
		bird=get_tree().get_first_node_in_group("bird")
		if bird: 
			bird.Gameover.connect(_request_game_over)
			bird.point.connect(_request_point)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _request_game_over() -> void:
	print("requested")
	if multiplayer.is_server():
		apply_game_over.rpc()
	else:
		request_game_over.rpc_id(1)
@rpc("any_peer", "call_remote")
func request_game_over() -> void:
	print("gameover")
	if not multiplayer.is_server():
		print("1")

		return
		
	if game_over:
		print("2")
		return
	print("reqthrough")
	apply_game_over.rpc()
		
@rpc("any_peer", "call_local")
func apply_game_over() -> void:

	if game_over:
		return
	%hit.play()
	game_over = true
	get_tree().paused = true
	%gameover.show()

	if score < 10:
		%finalscorebird1.texture = scores[score]
	elif score < 100:
		%finalscorebird2.show()
		%finalscorebird1.texture = scores[int(str(score)[0])]
		%finalscorebird2.texture = scores[int(str(score)[1])]
	else:
		%finalscorebird2.show()
		%finalscorebird3.show()
		%finalscorebird1.texture = scores[int(str(score)[0])]
		%finalscorebird2.texture = scores[int(str(score)[1])]
		%finalscorebird3.texture = scores[int(str(score)[2])]

	print("you lost")
func _request_point() -> void:
	if multiplayer.is_server():
		apply_point.rpc()

		
@rpc("any_peer", "call_remote")
func request_point() -> void:
	if not multiplayer.is_server():
		return
	apply_point.rpc()
	
@rpc("any_peer", "call_local")
func apply_point() -> void:
	score += 1
	print(score)
	%piont.play()
	if score < 10:
		%score.texture = scores[score]
	elif score < 100:
		%score2.show()
		%score.texture = scores[int(str(score)[0])]
		%score2.texture = scores[int(str(score)[1])]
	else:
		%score2.show()
		%score3.show()
		%score.texture = scores[int(str(score)[0])]
		%score2.texture = scores[int(str(score)[1])]
		%score3.texture = scores[int(str(score)[2])]
		

func _on_ground_body_entered(body: Node2D) -> void:
	if body is Bird:
		if multiplayer.is_server():
			apply_game_over.rpc()



func _on_replay_pressed() -> void:
	reset_scene.rpc()

@rpc("call_local")
func reset_scene():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_home_pressed() -> void:
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://home.tscn")
	
func _on_peer_disconnected(id: int) -> void:
	get_tree().paused = true
	are_you_sure.show()
func _on_server_disconnected():
	are_you_sure.show()




func _on_g_0_home_pressed() -> void:
	get_tree().change_scene_to_file("res://home.tscn")
