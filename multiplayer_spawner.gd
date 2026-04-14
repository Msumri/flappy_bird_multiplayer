extends MultiplayerSpawner

@export var network_player: PackedScene

var is_spawnd:=false

func _process(delta: float) -> void:
	if multiplayer.multiplayer_peer != null and is_spawnd==false:
		if multiplayer.is_server():
			await get_tree().process_frame
			call_deferred("spawn_player", 1)
			is_spawnd=true
		
func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return

	var player: Node = network_player.instantiate()
	
	# Node name is synchronized through MultiplayerSpawner, we can use this to set authority to the player.
	player.name = str(id)
	player.set_multiplayer_authority(id)

	get_node(spawn_path).call_deferred("add_child", player)
	player.position=Vector2(55,321)
	if multiplayer.is_server():
		$"../pipe_genrator".set_team(false)
		player.playable=true
	else:
		$"../pipe_genrator".set_team(true)# In this function, which is connected to the "host_started" signal in the high_level_network_handler
# class, we spawn the server player. Easy right?
func spawn_host_player() -> void:
	if !multiplayer.is_server(): return
	spawn_player(1)
