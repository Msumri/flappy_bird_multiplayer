extends MultiplayerSpawner

@export var network_player: PackedScene


var bird
func _ready() -> void:
		get_tree().paused = true
		if !multiplayer.is_server():
			%selectRoll.text="Host will pick thier Roll!"
			%bird.disabled=true
			%pip.disabled=true
@rpc("call_local","any_peer")	
func spawn_player(id: int) -> void:
	#if !multiplayer.is_server(): return

	var player: Node = network_player.instantiate()
	
	# Node name is synchronized through MultiplayerSpawner, we can use this to set authority to the player.
	player.name = str(id)
	player.set_multiplayer_authority(id)

	get_node(spawn_path).call_deferred("add_child", player)
	player.playable=true
 #In this function, which is connected to the "host_started" signal in the high_level_network_handler
# class, we spawn the server player. Easy right?
@rpc("any_peer", "call_local")
func on_choice(id:int):
	hidethings.rpc()

	
	if id==1:
		call_deferred("spawn_player", 1)
	else:
		if !multiplayer.is_server():
			spawn_player.rpc(multiplayer.get_unique_id())

@rpc("any_peer","call_local")	
func hidethings():
	get_tree().paused = false
	%select_yourRole.hide()

func _on_pip_pressed() -> void:
	$"../pipe_genrator".set_team.rpc(false)
	on_choice.rpc(2)

func _on_bird_pressed() -> void:
	on_choice(1)
	$"../pipe_genrator".set_team(false)
