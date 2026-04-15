extends Node

signal host_started()

const PORT: int = 42069 # Below 65535 (16-bit unsigned max value)
var ip:="localhsot"
var peer: ENetMultiplayerPeer
var p2_id:int
func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	var success = setup_upnp(PORT)
	
	if success:
		print("UPnP succeeded")
	else:
		print("UPnP failed (still trying to host anyway)")

	peer.create_server(PORT,2)
	multiplayer.multiplayer_peer = peer


func start_client(ip_input:String) -> void:
	ip=ip_input
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_input, PORT)
	multiplayer.multiplayer_peer = peer
	
# To create a server+player, or host player, we create a new function "start_host()".
# This function then starts the server like normal, but also calls a signal "host_started".
# Since this is an autoloaded class, other functions can connect to this signal, like I did
# in the "high_level_player_spawner". More comments there.
func start_host() -> void:
	start_server()
	host_started.emit()

func kill_connection():
	
	multiplayer.multiplayer_peer=null

func setup_upnp(port: int) -> bool:
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	if discover_result != UPNP.UPNP_RESULT_SUCCESS:
		return false
	
	if upnp.get_gateway() == null:
		return false
	
	var map_result = upnp.add_port_mapping(port)
	if map_result != UPNP.UPNP_RESULT_SUCCESS:
		return false
	
	print("External IP:", upnp.query_external_address())
	return true
