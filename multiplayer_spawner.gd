extends MultiplayerSpawner

@export var network_player: PackedScene

func _ready() -> void:

	if multiplayer.is_server():
		spawn_player(multiplayer.get_unique_id())


				
func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return

	var player: Node = network_player.instantiate()
	
	# Node name is synchronized through MultiplayerSpawner, we can use this to set authority to the player.
	player.name = str(id)
	player.set_multiplayer_authority(id)

	get_node(spawn_path).call_deferred("add_child", player)
	player.position=Vector2(55,321)
	$"../pipe_genrator".set_team.rpc(false)
# In this function, which is connected to the "host_started" signal in the high_level_network_handler
# class, we spawn the server player. Easy right?
func spawn_host_player() -> void:
	if !multiplayer.is_server(): return
	spawn_player(multiplayer.get_unique_id())
