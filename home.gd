extends Control

@onready var ipinput: LineEdit = $VBoxContainer/ipinput
var ready_players := 0
var expected_players := 1


func _on_host_pressed() -> void:	
	Multiplayer.start_host()
	%waiting.show()
	print("Host waiting for players...")
	
func _on_join_pressed() -> void:
	Multiplayer.start_client(ipinput.text)
	multiplayer.connected_to_server.connect(func():
		print("Connected to host")
		request_start.rpc_id(1)
	)
	%waiting.show()



@rpc("call_local")
func change_scene_rpc():
	await get_tree().create_timer(0.5).timeout
	if get_tree() != null:
		get_tree().change_scene_to_file("res://gmae.tscn")
		return
	#get_tree().change_scene_to_file("res://gmae.tscn")

@rpc("any_peer")
func request_start():
	if !multiplayer.is_server():
		return

	ready_players += 1
	print("Players ready: ", ready_players)

	if ready_players >= expected_players:
		change_scene_rpc.rpc()


func _on_x_pressed() -> void:
	Multiplayer.kill_connection()
	%waiting.hide()
