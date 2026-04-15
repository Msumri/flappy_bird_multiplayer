extends MultiplayerSpawner

@export var network_player: PackedScene

var is_spawnd:=false
var is_host_bird:=true
func _ready() -> void:
	get_tree().paused = true

func _process(delta: float) -> void:
	if multiplayer.multiplayer_peer != null and is_spawnd==false:
		if is_host_bird:
			if multiplayer.is_server():
				await get_tree().process_frame
				call_deferred("spawn_player", 1)
				is_spawnd=true
		else:
			await get_tree().process_frame
			call_deferred("spawn_player", 2)
			is_spawnd=true
		
func spawn_player(id: int) -> void:
	#if !multiplayer.is_server(): return

	var player: Node = network_player.instantiate()
	
	# Node name is synchronized through MultiplayerSpawner, we can use this to set authority to the player.
	player.name = str(id)
	player.set_multiplayer_authority(id)

	get_node(spawn_path).call_deferred("add_child", player)
	player.position=Vector2(55,321)
	if is_host_bird:
		$"../pipe_genrator".set_team(false)
		player.playable=true
	else:
		$"../pipe_genrator".set_team(true)
		player.playable=false# In this function, which is connected to the "host_started" signal in the high_level_network_handler
# class, we spawn the server player. Easy right?

	
@rpc("call_local")
func _check_host(boo:bool):
	is_host_bird=boo
	
func _on_pip_pressed() -> void:
	
	%select_yourRole.hide()
	get_tree().paused = false
	_check_host.rpc(false)
func _on_bird_pressed() -> void:
	
	%select_yourRole.hide()
	get_tree().paused = false
	_check_host.rpc(true)
